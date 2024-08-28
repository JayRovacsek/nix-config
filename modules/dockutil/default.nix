{
  config,
  pkgs,
  lib,
  ...
}:
let
  homeManagerHas =
    package:
    builtins.any (
      user:
      # Check if the package exists as a program option in home-manager
      if (builtins.hasAttr package user.programs) then
        user.programs."${package}".enable
      else
        builtins.any (p: lib.hasPrefix package p.name) user.home.packages
    ) (builtins.attrValues config.home-manager.users);

  # Logic becomes that a user has installed an application with X
  # name via homebrew nix module - this notably is possible to include masApps
  # see also: https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.masApps
  homeBrewHas =
    package:
    (
      builtins.elem package (builtins.map (x: x.name) config.homebrew.casks)
      || builtins.elem package (builtins.map (x: x.name) config.homebrew.brews)
      || builtins.elem package (builtins.attrNames config.homebrew.masApps)
    );

  anyUserHas = package: (homeBrewHas package || homeManagerHas package);

  alacrittyEntry.path = "${pkgs.alacritty}/Applications/Alacritty.app";
  firefoxEntry.path = "${pkgs.firefox-bin}/Applications/Firefox.app";
  braveEntry.path = "/Applications/Brave Browser.app";
  chromiumEntry.path = "/Applications/Chromium.app";
  vscodiumEntry.path = "${pkgs.vscodium}/Applications/VSCodium.app";
  keepassEntry.path = "${pkgs.keepassxc}/Applications/KeePassXC.app";
  outlookEntry.path = "/Applications/Microsoft Outlook.app";
  slackEntry.path = "${pkgs.slack}/Applications/Slack.app";
in
{
  imports = [ ../../options/dockutil ];

  dockutil = {
    enable = true;
    entries =
      (lib.optional (anyUserHas "alacritty") alacrittyEntry)
      ++ (lib.optional (anyUserHas "firefox") firefoxEntry)
      ++ (lib.optional (
        (anyUserHas "eloston-chromium") || (anyUserHas "chromium")
      ) chromiumEntry)
      ++ (lib.optional (anyUserHas "brave-browser") braveEntry)
      ++ (lib.optional (anyUserHas "keepassxc") keepassEntry)
      ++ [ outlookEntry ]
      ++ (lib.optional (anyUserHas "vscode") vscodiumEntry)
      ++ (lib.optional (anyUserHas "slack") slackEntry);
  };
}
