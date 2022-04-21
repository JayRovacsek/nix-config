{ config, pkgs, ... }: {
  imports = [
    ../../modules/alacritty
    ../../modules/firefox
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
