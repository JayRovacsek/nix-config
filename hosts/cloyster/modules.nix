{ config, pkgs, ... }: {
  imports = [
    ../../modules/documentation
    ../../modules/fonts
    ../../modules/gnupg
    ../../modules/homebrew
    ../../modules/lorri
    ../../modules/mac-dock
    ../../modules/networking
    ../../modules/nix
    ../../modules/time
    ../../modules/zsh
  ];

  mac-dock = {
    enable = true;
    entries = [
      { path = "${pkgs.alacritty.outPath}/Applications/Alacritty.app"; }
      { path = "${pkgs.firefox-bin.outPath}/Applications/Firefox.app"; }
      { path = "/Applications/Brave Browser.app"; }
      { path = "/Applications/Chromium.app"; }
      { path = "${pkgs.vscode.outPath}/Applications/Visual Studio Code.app"; }
      { path = "/Applications/KeePassXC.app"; }
      { path = "/Applications/Microsoft Outlook.app"; }
      { path = "/Applications/Slack.app"; }
      # Temporary additions:
      { path = "/Applications/Keka.app"; }
      { path = "/Applications/VMware Fusion.app"; }
    ];
  };
}
