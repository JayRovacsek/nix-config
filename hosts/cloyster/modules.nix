{ config, pkgs, ... }:
let nixConfig = import ../../modules/nix { pkgs = pkgs; };
in {
  imports = [
    ../../modules/alacritty
    ../../modules/documentation
    ../../modules/fonts
    ../../modules/gnupg
    ../../modules/homebrew
    ../../modules/lorri
    ../../modules/lsd
    ../../modules/mac-dock
    ../../modules/networking
    ../../modules/nix
    ../../modules/starship
    ../../modules/time
    ../../modules/vscodium
    ../../modules/zsh
  ];

  mac-dock = {
    enable = true;
    entries = [
      { path = "${pkgs.alacritty.outPath}/Applications/Alacritty.app"; }
      { path = "/Applications/Firefox.app"; }
      { path = "${pkgs.vscodium.outPath}/Applications/VSCodium.app"; }
      { path = "/Applications/KeePassXC.app"; }
      { path = "/Applications/Microsoft Outlook.app"; }
      { path = "/Applications/Slack.app"; }
    ];
  };
}
