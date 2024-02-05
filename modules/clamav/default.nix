{ pkgs, lib, ... }: {
  # Required as DNS may not be immediately available on a system if
  # blocky is being used while the bootstrap occurs.
  # 
  # Block updates for 5 minutes on a freshly booted system.
  systemd.timers.clamav-freshclam.timerConfig.OnBootSec = 300;

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
        VirusEvent = lib.escapeShellArgs [
          "${pkgs.libnotify}/bin/notify-send"
          "--"
          "ClamAV Virus Scan"
          "Found virus: %v"
        ];
      };
    };

    scanner = {
      enable = true;
      scanDirectories = [ "/etc" "/home" "/srv" "/tmp" "/var/lib" "/var/tmp" ];
    };

    updater = {
      enable = true;
      frequency = 24;
      interval = "hourly";
    };
  };
  environment.systemPackages = with pkgs; [ libnotify ];
}
