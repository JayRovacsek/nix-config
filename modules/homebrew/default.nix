{
  # I don't want to use this, but will likely need to
  homebrew = {
    enable = true;
    autoUpdate = true;
    cleanup = "zap";
    brews = [ "openssh" "pidof" ];

    casks = [
      "brave-browser"
      "eloston-chromium"
      "discord"
      "gimp"
      "jellyfin-media-player"
      "keepassxc"
      "signal"
      "slack"
    ];
  };
}
