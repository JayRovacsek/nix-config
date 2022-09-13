{
  # I don't want to use this, but will likely need to
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    brews = [ "openssh" "pidof" "mas" ];

    casks = [
      "brave-browser"
      "discord"
      "eloston-chromium"
      "gimp"
      "jellyfin-media-player"
      "keepassxc"
      "keepingyouawake"
      "microsoft-remote-desktop"
      "raycast"
      "signal"
      "slack"
      "zoom"
    ];

    masApps = {
      "Microsoft Excel" = 462058435;
      "Microsoft Outlook" = 985367838;
      "Microsoft PowerPoint" = 462062816;
      "Microsoft Word" = 462054704;
      OneDrive = 823766827;
      Xcode = 497799835;
    };
  };
}
