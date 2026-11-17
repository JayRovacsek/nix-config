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

  # Headscale 0.28+ requires every pre-auth key to be either user-owned or
  # tagged (never neither). These keys are tagged, so nodes registered with
  # them become tagged devices owned by the special "tagged-devices" user.
  preauth-key = {
    options = with types; {
      name = mkOption {
        type = str;
        description = "Label for the key; used to derive the default tag.";
      };

      path = mkOption {
        type = path;
        description = "Path to the decrypted plaintext pre-auth key.";
      };

      tags = mkOption {
        type = nullOr (listOf str);
        default = null;
        description = "Tags applied to nodes registered with this key. Defaults to [\"tag:<name>\"].";
      };

      ephemeral = mkOption {
        type = bool;
        default = true;
      };

      reusable = mkOption {
        type = bool;
        default = true;
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

  # Build the tags column value with SQLite's json_array() rather than
  # embedding a JSON literal. The whole statement is wrapped in double quotes
  # (so $KEY_CONTENT expands), and a literal '["tag:x"]' would carry double
  # quotes that terminate that wrapper early — the shell then strips them and
  # stores '[tag:x]', which headscale's GORM serializer:json cannot parse
  # ("invalid character 'a' in literal true"). json_array uses only single
  # quotes, so it survives the shell quoting and yields valid JSON.
  tags-sql =
    key:
    let
      tagsList = if key.tags != null then key.tags else [ "tag:${key.name}" ];
    in
    "json_array(" + builtins.concatStringsSep "," (map (t: "'${t}'") tagsList) + ")";

  # The 'key' column no longer has a UNIQUE constraint (only 'prefix' does),
  # so INSERT OR IGNORE cannot deduplicate. Guard with WHERE NOT EXISTS to
  # keep the insert idempotent across reactivations.
  insert-key = key: ''
    KEY_CONTENT=$(tr -d '\r\n' < ${key.path})
    ${pkgs.sqlite-interactive}/bin/sqlite3 -cmd ".timeout 5000" ${cfg.settings.database.sqlite.path} "INSERT INTO pre_auth_keys (key, tags, reusable, ephemeral) SELECT '$KEY_CONTENT', ${tags-sql key}, ${bool-to-int key.reusable}, ${bool-to-int key.ephemeral} WHERE NOT EXISTS (SELECT 1 FROM pre_auth_keys WHERE key = '$KEY_CONTENT');"
  '';

  script = ''
    # Wait for the database to be created by Headscale
    while [ ! -f ${cfg.settings.database.sqlite.path} ]; do
      echo "Waiting for database file to be created..."
      sleep 1
    done

    # Wait for tables to be created (simple check for 'pre_auth_keys' table)
    until ${pkgs.sqlite-interactive}/bin/sqlite3 ${cfg.settings.database.sqlite.path} "SELECT count(*) FROM pre_auth_keys;" >/dev/null 2>&1; do
      echo "Waiting for tables to be initialised..."
      sleep 1
    done

    ${builtins.concatStringsSep "\n" (map insert-key cfg.preauthKeys)}
  '';

  # Headscale 0.28+ (policy v2) rejects a policy at startup when a tag used
  # in the acls is not declared in tagOwners. Every tag here originates from
  # a pre-auth key, so declare those, each owned by the placeholder admin user.
  # Merging attrsets (//) deduplicates tags shared across keys. Invariant: any
  # custom acl.acls must only reference tags that also appear on a preauthKey,
  # otherwise that tag would be missing from tagOwners and startup would fail.
  tag-owners = builtins.foldl' (
    acc: key:
    acc
    // builtins.listToAttrs (
      builtins.map (tag: {
        name = tag;
        value = [ cfg.acl.tagOwner ];
      }) (if key.tags != null then key.tags else [ "tag:${key.name}" ])
    )
  ) { } cfg.preauthKeys;

in
{
  options.services.headscale = {
    preauthKeys = mkOption {
      type = with types; listOf (submodule preauth-key);
      default = [ ];
      description = "Declarative pre-auth keys inserted directly into the Headscale database.";
    };

    acl = {
      acls = mkOption {
        type = with types; listOf (submodule aclRule);
        default = [ ];
        description = "Defines the ACL rules.";
      };

      tagOwner = mkOption {
        type = types.str;
        default = "admin@";
        description = ''
          Owner recorded for every tag in the generated policy's tagOwners.
          Headscale 0.28+ (policy v2) rejects a policy at startup when a tag
          used in the acls is not declared in tagOwners. Since these keys are
          userless, a placeholder admin user is used; the v2 parser accepts a
          user token that has not registered yet (it resolves to an empty set).
        '';
      };
    };
  };

  config = lib.mkIf (cfg.preauthKeys != [ ]) {
    # Policy v2 (v1 support was removed upstream in 0.27): acls referencing
    # tags, plus a tagOwners entry for each tag (required since 0.28). Unknown
    # fields are rejected at load time, so the old lowercase "groups" key must
    # not be emitted.
    services.headscale.settings.policy.path = pkgs.writeText "acl.json" (
      builtins.toJSON {
        tagOwners = tag-owners;
        acls = builtins.map (rule: lib.filterAttrs (_n: v: v != null) rule) cfg.acl.acls;
      }
    );

    systemd.services.headscale-preauth-setup = {
      inherit script;

      description = "Declarative configuration of Headscale pre-auth keys";

      # Run AFTER headscale to ensure DB is initialised, and after agenix so
      # the decrypted secret files exist
      after = [
        "agenix.service"
        "headscale.service"
      ];
      wants = [ "headscale.service" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        bash
        coreutils
        sqlite-interactive
      ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "oneshot";
        RemainAfterExit = true;
        StateDirectory = "headscale";
      };
    };
  };
}
