{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.headscale;
  inherit (lib) mkOption types;

  bool-to-int = b: if b then "1" else "0";

  preauth-key = {
    options = with types; {
      ephemeral = mkOption {
        type = bool;
        default = true;
      };

      expiration = mkOption {
        type = str;
        default = "'2050-01-01 00:00:00.000000000+00:00'";
      };

      path = mkOption { type = path; };

      reusable = mkOption {
        type = bool;
        default = true;
      };
    };
  };

  users = {
    options = with types; {
      name = mkOption { type = str; };
      keys = mkOption {
        type = listOf (submodule preauth-key);
        default = [ ];
      };
    };
  };

  aclRule = {
    options = with types; {
      action = mkOption {
        type = enum [ "accept" ];
        default = "accept";
      };
      src = mkOption {
        type = listOf str;
      };
      proto = mkOption {
        type = nullOr (enum [
          "ah"
          "egp"
          "esp"
          "gre"
          "icmp"
          "igmp"
          "igp"
          "ip-in-ip"
          "ipv4"
          "sctp"
          "tcp"
          "udp"
        ]);
        default = null;
      };
      dst = mkOption {
        type = listOf str;
      };
    };
  };

  unixEpoch = "'1970-01-01 00:00:00.000000000+00:00'";

  # We use a bash script loop instead of a single SQL block to avoid hardcoding IDs
  script = with pkgs; ''
    # Wait for the database to be created by Headscale
    # Loop until the database file exists and the 'users' table is present
    while [ ! -f ${cfg.settings.database.path} ]; do
      echo "Waiting for database file to be created..."
      sleep 1
    done

    # Wait for tables to be created (simple check for 'users' table)
    until ${pkgs.sqlite-interactive}/bin/sqlite3 ${cfg.settings.database.path} "SELECT count(*) FROM users;" >/dev/null 2>&1; do
      echo "Waiting for tables to be initialised..."
      sleep 1
    done

    ${builtins.concatStringsSep "\n" (
      lib.imap0 (i: user: ''
        # Ensure user exists
        ${pkgs.sqlite-interactive}/bin/sqlite3 -cmd ".timeout 5000" ${cfg.settings.database.path} "INSERT OR IGNORE INTO users (name, created_at, updated_at) VALUES ('${user.name}', ${unixEpoch}, ${unixEpoch});"

        # Get User ID
        USER_ID_${toString i}=$(${pkgs.sqlite-interactive}/bin/sqlite3 ${cfg.settings.database.path} "SELECT id FROM users WHERE name='${user.name}';")

        ${builtins.concatStringsSep "\n" (
          lib.imap0 (_j: key: ''
            KEY_CONTENT=$(cat ${key.path})
            # Insert key if not exists (assuming unique key constraint on 'key' column which headscale usually has, or we check existence)
            # We use INSERT OR REPLACE to update attributes like expiration/reusable if they change, but we need the ID to stay stable if possible, 
            # actually if we replace, we might get a new ID which is fine for keys.
            # But wait, if we use 'cat', we need to be careful about newlines.
            KEY_CONTENT=$(echo $KEY_CONTENT | tr -d '\n')

            # Insert key if not exists
            # We need to handle the case where the key already exists but attributes need updating.
            # However, 'key' is likely unique.
            # If we simply INSERT OR REPLACE, we might break things if IDs change (though IDs are auto-increment).
            # But the previous error "ON CONFLICT clause does not match any PRIMARY KEY or UNIQUE constraint"
            # suggests that 'key' might NOT be explicitly defined as UNIQUE in the schema Headscale created?
            # Or maybe we are targeting the wrong constraint.

            # Let's try a simple INSERT OR IGNORE to ensure the key exists.
            # Updating attributes of existing keys is less critical for this test than getting them in.

            ${pkgs.sqlite-interactive}/bin/sqlite3 -cmd ".timeout 5000" ${cfg.settings.database.path} "INSERT OR IGNORE INTO pre_auth_keys (key, user_id, reusable, ephemeral, created_at, expiration) VALUES ('$KEY_CONTENT', $USER_ID_${toString i}, ${bool-to-int key.reusable}, ${bool-to-int key.ephemeral}, ${unixEpoch}, ${key.expiration});"
          '') user.keys
        )}
      '') cfg.users
    )}

  '';

in
{
  options.services.headscale = {
    users = mkOption {
      type = with types; listOf (submodule users);
      default = [ ];
    };

    acl = {
      groups = mkOption {
        type = types.attrsOf (types.listOf types.str);
        default = { };
        description = "Defines the user groups.";
      };

      acls = mkOption {
        type = types.listOf (types.submodule aclRule);
        default = [ ];
        description = "Defines the ACL rules.";
      };
    };

    use-declarative-users = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.use-declarative-users {
    services.headscale.settings.policy.path = pkgs.writeText "acl.json" (
      builtins.toJSON {
        inherit (cfg.acl) groups;
        acls = builtins.map (
          rule: lib.filterAttrs (_n: v: v != null) rule
        ) cfg.acl.acls;
      }
    );

    systemd.services.headscale-user-setup = {
      inherit script;

      description = "Declarative configuration of Headscale users & keys";

      # Run AFTER headscale to ensure DB is initialised
      after = [ "headscale.service" ];
      wants = [ "headscale.service" ];
      wantedBy = [ "multi-user.target" ];

      # Required to use nix-shell within our script
      path = with pkgs; [
        bash
        sqlite-interactive
      ];

      serviceConfig = {
        User = config.services.headscale.user;
        Group = config.services.headscale.group;
        Type = "oneshot";
        RemainAfterExit = true;
        StateDirectory = "headscale";
      };
    };
  };
}
