{ config, pkgs, self, ... }:
let
  inherit (self.lib) merge;

  defaults = {
    exclude = [ ];
    extraBackupArgs = [ ];
    extraOptions = [ ];
    initialize = true;
    paths = [ ];
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 10"
    ];
  };

  nextcloud-local-disk-backup = {
    nextcloud-local-disk-backup = merge [
      defaults
      rec {
        backupPrepareCommand =
          "${pkgs.restic}/bin/restic -r ${repository} unlock";
        passwordFile = config.age.secrets.nextcloud-password.path;
        paths = [
          "/srv/nextcloud"
          "/var/lib/${builtins.hashString "md5" "nidoking"}/nextcloud"
          "/var/lib/${builtins.hashString "md5" "nidoking"}/mysql"
        ];
        repository = "/mnt/backup/restic/nextcloud";
        timerConfig = null;
      }
    ];
  };

  logs-wasabi-backup = {
    logs-wasabi-backup = merge [
      defaults
      rec {
        backupPrepareCommand =
          "${pkgs.restic}/bin/restic -r ${repository} unlock";
        environmentFile = config.age.secrets.wasabi-backup-env.path;
        extraOptions = [ "limit-upload=4096" "compression=max" ];
        passwordFile = config.age.secrets.logs-password.path;
        paths = [ "/srv/logs" ];
        repository =
          "s3:https://s3.ap-southeast-2.wasabisys.com/sduhk02qkjfwuhoc6onreor4a99dhp0v";
        timerConfig = {
          OnCalendar = "hourly";
          Persistent = true;
        };
      }
    ];
  };

  nextcloud-wasabi-backup = {
    nextcloud-wasabi-backup = merge [
      defaults
      rec {
        backupPrepareCommand =
          "${pkgs.restic}/bin/restic -r ${repository} unlock";
        environmentFile = config.age.secrets.wasabi-backup-env.path;
        extraOptions = [ "limit-upload=4096" "compression=max" ];
        passwordFile = config.age.secrets.nextcloud-password.path;
        paths = [
          "/srv/nextcloud"
          "/var/lib/${builtins.hashString "md5" "nidoking"}/nextcloud"
          "/var/lib/${builtins.hashString "md5" "nidoking"}/mysql"
        ];
        repository =
          "s3:https://s3.ap-southeast-2.wasabisys.com/sduhk02qkjfwuhoc6onreor4a99dhp0u";
        timerConfig = {
          OnCalendar = "00:05";
          Persistent = true;
          RandomizedDelaySec = "5h";
        };
      }
    ];
  };
in {

  age = {
    identityPaths = [ "/agenix/id-ed25519-restic-primary" ];
    secrets = {
      nextcloud-password.file = ../../secrets/restic/nextcloud-password.age;
      logs-password.file = ../../secrets/restic/logs-password.age;
      wasabi-backup-env.file = ../../secrets/restic/wasabi-backup-env.age;
    };
  };

  services.restic.backups = merge [
    logs-wasabi-backup
    nextcloud-local-disk-backup
    nextcloud-wasabi-backup
  ];
}
