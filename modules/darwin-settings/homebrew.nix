{ config, ... }:
let
  inherit (config.networking) hostName;
  extraCasks =
    if hostName == "victreebel" then
      [
        "tableau"
        "workplace-chat"
      ]
    else
      [ ];
  forceBrewInstall = name: {
    inherit name;
    args = [ "force" ];
  };
in
{
  # Required for homebrew on aarch64, TODO: add x86 locations
  environment.systemPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    brews = builtins.map forceBrewInstall [
      "openssh"
      "pidof"
      "mas"
      "mingw-w64"
    ];

    casks = [
      "brave-browser"
      "eloston-chromium"
      "gimp"
      "jellyfin-media-player"
      "keepingyouawake"
      "microsoft-remote-desktop"
      "nextcloud"
      "raycast"
      "signal"
      "zed"
      "zoom"
    ] ++ extraCasks;

    masApps = {
      "Tailscale" = 1475387142;
    };
  };
}
