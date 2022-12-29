{ config, ... }:
let
  inherit (config.networking) hostName;
  extraCasks = if hostName == "victreebel" then [ "workplace-chat" ] else [ ];
in {
  # I don't want to use this, but will likely need to
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    brews = [ "openssh" "pidof" "mas" "mingw-w64" ];

    casks = [
      "brave-browser"
      "discord"
      "eloston-chromium"
      "gimp"
      "jellyfin-media-player"
      "keepassxc"
      "keepingyouawake"
      "microsoft-remote-desktop"
      "nextcloud"
      "raycast"
      "signal"
      "slack"
    ] ++ extraCasks;

    masApps = { };
  };
}
