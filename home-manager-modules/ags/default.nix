{ pkgs, osConfig, ... }: {
  programs.ags = {
    enable = true;
    configDir = osConfig.flake.inputs.ags-config.outPath + "/src";
  };

  home.packages = with pkgs; [
    # Required for brightness control
    brightnessctl
    # Required to build ags config
    bun
    # Required for theme icons
    adw-gtk3
    # Required for system tray
    libdbusmenu-gtk3
  ];
}
