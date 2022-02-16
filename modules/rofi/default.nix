{ config, pkgs, ... }: {
  home-manager.users.jay.programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = ./themes/launchpad.rasi;
    extraConfig = { modi = "drun"; };
  };
}
