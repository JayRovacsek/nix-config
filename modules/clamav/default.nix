{ config, lib, ... }:
{
  # Required as DNS may not be immediately available on a system if
  # blocky is being used while the bootstrap occurs.
  systemd.services.clamav-freshclam = {
    after = lib.optional config.services.blocky.enable "blocky.service";
  };

  services.clamav = {
    daemon = {
      enable = true;
      settings = {
        DetectPUA = true;
        ExtendedDetectionInfo = true;
        FollowDirectorySymlinks = true;
        FollowFileSymlinks = true;
        LogFile = "/var/log/clamd.log";
        LogSyslog = true;
        LogTime = true;
        MaxDirectoryRecursion = 30;
        OnAccessExcludeUname = "clamav";
        OnAccessExtraScanning = true;
        OnAccessPrevention = true;
      };
    };

    scanner = {
      enable = true;
      scanDirectories = [
        "/etc"
        "/home"
        "/srv"
        "/tmp"
        "/var/lib"
        "/var/tmp"
      ];
    };

    updater = {
      enable = true;
      frequency = 24;
      interval = "hourly";
    };
  };
}
