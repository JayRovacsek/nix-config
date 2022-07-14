{ config, pkgs, ... }: {
  imports = [
    ../../modules/documentation
    ../../modules/fonts
    ../../modules/gnupg
    ../../modules/homebrew
    ../../modules/lorri
    ../../modules/mac-dock
    ../../modules/networking
    (import ../../modules/nix {
      inherit config;
      arch = "aarch64-darwin";
    })
    ../../modules/time
    ../../modules/yabai
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
      { path = "/Applications/Slack.app"; }
    ];
  };
}
