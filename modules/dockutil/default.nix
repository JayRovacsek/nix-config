{ config, pkgs, ... }:
let
  alacrittyEntry = {
    path = "${pkgs.alacritty.outPath}/Applications/Alacritty.app";
  };
  firefoxEntry = {
    path = "${pkgs.firefox-bin.outPath}/Applications/Firefox.app";
  };
  braveEnrty = { path = "/Applications/Brave Browser.app"; };
  chromiumEntry = { path = "/Applications/Chromium.app"; };
  vscodeEntry = {
    path = "${pkgs.vscode.outPath}/Applications/Visual Studio Code.app";
  };
  keepassEntry = { path = "/Applications/KeePassXC.app"; };
  outlookEntry = { path = "/Applications/Microsoft Outlook.app"; };
  slackEntry = { path = "/Applications/Slack.app"; };
in {

  imports = [ ../../options/dockutil ];

  dockutil = {
    enable = true;
    entries = [
      alacrittyEntry
      firefoxEntry
      braveEnrty
      chromiumEntry
      vscodeEntry
      keepassEntry
      outlookEntry
      slackEntry
    ];
  };
}
