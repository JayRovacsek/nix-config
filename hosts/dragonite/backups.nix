{ config, self, ... }:
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
      {
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

  nextcloud-wasabi-backup = {
    nextcloud-wasabi-backup = merge [
      defaults
      {
        environmentFile = config.age.secrets.nextcloud-wasabi-backup-env.path;
        extraOptions = [ "--limit-upload=1024" "--compression=max" ];
        passwordFile = config.age.secrets.nextcloud-password.path;
        paths = [
          "/srv/nextcloud"
          "/var/lib/${builtins.hashString "md5" "nidoking"}/nextcloud"
          "/var/lib/${builtins.hashString "md5" "nidoking"}/mysql"
        ];
        repository =
          "s3:https://s3.ap-southeast-2.wasabisys.com/sduhk02qkjfwuhoc6onreor4a99dhp0u";
        timerConfig = {
          OnCalendar = "hourly";
          Persistent = true;
        };
      }
    ];
  };
in {

  age = {
    identityPaths = [ "/agenix/id-ed25519-restic-primary" ];
    secrets = {
      nextcloud-password.file = ../../secrets/restic/nextcloud-password.age;
      nextcloud-wasabi-backup-env.file =
        ../../secrets/restic/nextcloud-wasabi-backup-env.age;
    };
  };

  services.restic.backups =
    merge [ nextcloud-local-disk-backup nextcloud-wasabi-backup ];
}
