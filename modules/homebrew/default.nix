{
  # I don't want to use this, but will likely need to
  homebrew = {
    enable = true;
    autoUpdate = true;
    cleanup = "zap";
    brews = [ "openssh" ];

    casks = [
      "discord"
      "firefox"
      "gimp"
      "jellyfin-media-player"
      "keepassxc"
      "signal"
      "slack"
      "zoom"
    ];
  };
}
