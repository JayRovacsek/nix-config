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
      # TODO: build check to ensure uniqueness across users for
      # ID otherwise we'll create issues (plus non-zero/negative etc)
      id = mkOption { type = int; };
      name = mkOption { type = str; };
      keys = mkOption {
        type = listOf (submodule preauth-key);
        default = [ ];
      };
    };
  };

  unixEpoch = "'1970-01-01 00:00:00.000000000+00:00'";

  sql-statement = builtins.concatStringsSep "\n" (
    lib.imap0 (i: user: ''
      INSERT OR REPLACE INTO users ('id','created_at','updated_at','name') VALUES (${builtins.toString user.id}, ${unixEpoch},${unixEpoch},'${user.name}');

      ${builtins.concatStringsSep "\n" (
        lib.imap0 (j: key: ''
          INSERT OR REPLACE INTO pre_auth_keys ('id','key','user_id','reusable','ephemeral','created_at','expiration') VALUES (${
            # TODO: same constraint as the tailnet primary key - ensure uniqueness
            builtins.toString (j + (i * 64))
          },'`cat ${key.path}`',${builtins.toString user.id},${bool-to-int key.reusable},${bool-to-int key.ephemeral},${unixEpoch},${key.expiration});
        '') user.keys
      )}

    '') cfg.users
  );

  script = with pkgs; ''
    bash -c "
    ${pkgs.sqlite-interactive}/bin/sqlite3 ${cfg.settings.db_path} <<'END_SQL'

    ${sql-statement}

    END_SQL"
  '';

in
{
  options.services.headscale = {
    users = mkOption {
      type = with types; listOf (submodule users);
      default = [ ];
    };

    use-declarative-users = mkOption {
      type = with types; bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.use-declarative-users {
    systemd.services.headscale-user-setup = {
      inherit script;

      description = "Declarative configuration of Headscale users & keys";

      # make sure we perform actions prior to headscale starting
      after = [ "headscale.service" ];
      wants = [ "headscale.service" ];

      # Required to use nix-shell within our script
      path = with pkgs; [
        bash
        sqlite-interactive
      ];

      serviceConfig = {
        User = config.services.headscale.user;
        Group = config.services.headscale.group;
        Type = "oneshot";
      };
    };
  };
}
