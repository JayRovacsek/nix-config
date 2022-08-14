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
  vscodiumEntry = {
    path = "${pkgs.vscodium.outPath}/Applications/VSCodium.app";
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
      vscodiumEntry
      keepassEntry
      outlookEntry
      slackEntry
    ];
  };
}
