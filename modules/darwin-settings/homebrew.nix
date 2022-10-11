{
  # I don't want to use this, but will likely need to
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    brews = [ "openssh" "pidof" "mas" "mingw-w64" ];

    casks = [
      "amethyst"
      "brave-browser"
      "discord"
      "eloston-chromium"
      "gimp"
      "jellyfin-media-player"
      "keepassxc"
      "nextcloud"
      "keepingyouawake"
      "microsoft-remote-desktop"
      "raycast"
      "signal"
      "slack"
    ];

    masApps = { };
  };
}
