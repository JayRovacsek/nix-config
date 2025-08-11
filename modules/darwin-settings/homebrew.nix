_:
let
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
      "mingw-w64"
    ];

    casks = [
      "jellyfin-media-player"
      "keepingyouawake"
      "nextcloud"
      "signal"
      "zoom"
    ];
  };
}
