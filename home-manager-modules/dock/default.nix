{
  config,
  pkgs,
  lib,
  osConfig,
  self,
  ...
}:
let
  homeManagerHas =
    package:
    # Check if the package exists as a program option in home-manager
    if (builtins.hasAttr package config.programs) then
      config.programs."${package}".enable
    else
      builtins.any (p: lib.hasPrefix package (p.pname or p.name)) config.home.packages;

  # Logic becomes that a user has installed an application with X
  # name via homebrew nix module - this notably is possible to include masApps
  # see also: https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.masApps
  homeBrewHas =
    package:
    (
      builtins.elem package (builtins.map (x: x.pname or x.name) osConfig.homebrew.casks)
      || builtins.elem package (builtins.map (x: x.name) osConfig.homebrew.casks)
      || builtins.elem package (builtins.map (x: x.pname or x.name) osConfig.homebrew.brews)
      || builtins.elem package (builtins.map (x: x.name) osConfig.homebrew.brews)
      || builtins.elem package (builtins.attrNames osConfig.homebrew.masApps)
    );

  anyUserHas = package: (homeManagerHas package || homeBrewHas package);

  alacrittyEntry.path = "${pkgs.alacritty}/Applications/Alacritty.app";
  braveEntry.path = "${pkgs.brave}/Applications/Brave Browser.app";
  firefoxEntry.path = "${pkgs.firefox}/Applications/Firefox.app";
  keepassEntry.path = "${pkgs.keepassxc}/Applications/KeePassXC.app";
  outlookEntry.path = "/Applications/Microsoft Outlook.app";
  slackEntry.path = "${pkgs.slack}/Applications/Slack.app";
  vscodiumEntry.path = "${pkgs.vscodium}/Applications/VSCodium.app";
in
{
  imports = [ ../../options/home-manager-modules/dock ];

  nixpkgs.overlays = [ self.overlays.dockutil-bin ];

  home.dock = {
    enable = true;
    entries =
      (lib.optional (anyUserHas "alacritty") alacrittyEntry)
      ++ (lib.optional (anyUserHas "firefox") firefoxEntry)
      ++ (lib.optional (anyUserHas "brave") braveEntry)
      ++ (lib.optional (anyUserHas "keepassxc") keepassEntry)
      ++ [ outlookEntry ]
      ++ (lib.optional (anyUserHas "vscode") vscodiumEntry)
      ++ (lib.optional (anyUserHas "slack") slackEntry);
  };
}
