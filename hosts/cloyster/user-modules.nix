{ config, pkgs, ... }:
let nixConfig = import ../../modules/nix { pkgs = pkgs; };
in {
  imports = [
    ../../modules/alacritty
    ../../modules/lsd
    # ../../modules/mac-dock
    ../../modules/starship
    ../../modules/vscodium

    ../../packages/x86_64-darwin.nix
  ];

  # mac-dock = {
  #   enable = true;
  #   entries = [
  #     { path = "${pkgs.alacritty.outPath}/Applications/Alacritty.app"; }
  #     { path = "/Applications/Firefox.app"; }
  #     { path = "${pkgs.vscode.outPath}/Applications/VSCodium.app"; }
  #     { path = "/Applications/KeePassXC.app"; }
  #     { path = "/Applications/Microsoft Outlook.app"; }
  #     { path = "/Applications/Slack.app"; }
  #   ];
  # };
}
