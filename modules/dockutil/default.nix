{ config, pkgs, lib, ... }:
let
  homeManagerHas = package:
    builtins.any (user:
      # Check if the package exists as a program option in home-manager
      if (builtins.hasAttr package user.programs) then
        user.programs."${package}".enable
      else
        builtins.any (p: lib.hasPrefix package p.name) user.home.packages)
    (builtins.attrValues config.home-manager.users);

  # Logic becomes that a user has installed an application with X
  # name via homebrew nix module - this notably is possible to include masApps
  # see also: https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.masApps
  homeBrewHas = package:
    (builtins.elem package (builtins.map (x: x.name) config.homebrew.casks)
      || builtins.elem package (builtins.map (x: x.name) config.homebrew.brews)
      || builtins.elem package (builtins.attrNames config.homebrew.masApps));

  anyUserHas = package: (homeBrewHas package || homeManagerHas package);

  alacrittyEntry = [{ path = "${pkgs.alacritty}/Applications/Alacritty.app"; }];
  firefoxEntry = [{ path = "${pkgs.firefox-bin}/Applications/Firefox.app"; }];
  braveEntry = [{ path = "/Applications/Brave Browser.app"; }];
  chromiumEntry = [{ path = "/Applications/Chromium.app"; }];
  vscodiumEntry = [{ path = "${pkgs.vscodium}/Applications/VSCodium.app"; }];
  keepassEntry = [{ path = "${pkgs.keepassxc}/Applications/KeePassXC.app"; }];
  outlookEntry = [{ path = "/Applications/Microsoft Outlook.app"; }];
  slackEntry = [{ path = "${pkgs.slack}/Applications/Slack.app"; }];
  utmEntry = [{ path = "${pkgs.utm}/Applications/UTM.app"; }];

  entries = (if anyUserHas "alacritty" then alacrittyEntry else [ ])
    ++ (if anyUserHas "firefox" then firefoxEntry else [ ])
    ++ (if anyUserHas "brave-browser" then braveEntry else [ ])
    ++ (if anyUserHas "eloston-chromium" || anyUserHas "chromium" then
      chromiumEntry
    else
      [ ])
    # Gross hack - TODO: fix later
    ++ (if anyUserHas "vscode" then vscodiumEntry else [ ])
    ++ (if anyUserHas "keepassxc" then keepassEntry else [ ])
    ++ (if anyUserHas "Microsoft Outlook" then outlookEntry else [ ])
    ++ (if anyUserHas "slack" then slackEntry else [ ])
    ++ (if anyUserHas "utm" then utmEntry else [ ]);

in {
  imports = [ ../../options/dockutil ];

  dockutil = {
    enable = true;
    inherit entries;
  };
}
