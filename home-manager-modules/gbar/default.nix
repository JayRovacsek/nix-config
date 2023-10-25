{ lib, osConfig, ... }:
let
  inherit (lib) hasInfix;
  isLinux = hasInfix "linux" osConfig.nixpkgs.system;
  isx86_64 = hasInfix "x86_64" osConfig.nixpkgs.system;
  gbar-available = isLinux && isx86_64;
  cfg = lib.optionalAttrs gbar-available {
    programs.gBar = {
      enable = true;
      extraCSS = "";
      config = {
        # TODO: resolve to suitable values as per: https://github.com/scorpion-26/gBar/blob/master/module.nix
        # AudioInput = true;
        # AudioMaxVolume = true;
        # AudioMinVolume = true;
        # AudioNumbers = true;
        # AudioRevealer = true;
        # AudioScrollSpeed = true;
        # BatteryFolder = true;
        # CPUThermalZone = true;
        # CenterTime = true;
        # DateTimeLocale = true;
        # DateTimeStyle = true;
        # DefaultWorkspaceSymbol = true;
        # DiskPartition = true;
        # EnableSNI = true;
        # ExitCommand = true;
        # Location = true;
        # LockCommand = true;
        # MaxDownloadBytes = true;
        # MaxUploadBytes = true;
        # MinDownloadBytes = true;
        # MinUploadBytes = true;
        # NetworkAdapter = true;
        # NetworkWidget = true;
        # NumWorkspaces = true;
        # SNIIconPaddingTop = true;
        # SNIIconSize = true;
        # SensorTooltips = true;
        # SuspendCommand = true;
        # TimeSpace = true;
        # UseHyprlandIPC = true;
        # WorkspaceScrollInvert = true;
        # WorkspaceScrollOnMonitor = true;
        # WorkspaceSymbols = true;
      };
    };
  };
in cfg
