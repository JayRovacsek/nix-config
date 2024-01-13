{ pkgs, lib, ... }: {
  # Inspiration: https://github.com/houstdav000/dotfiles/blob/733f2db667e3645619ca9dc05446099864045a49/nixos/config/services/clamav.nix
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
