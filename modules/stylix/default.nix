{ config, pkgs, ... }:
let
  inherit (config.flake.inputs.nixpkgs.legacyPackages.x86_64-linux)
    base16-schemes;
in {
  stylix = {
    autoEnable = true;
    base16Scheme = "${base16-schemes}/share/themes/tokyo-night-dark.yaml";
    # fonts
    homeManagerIntegration.followSystem = true;
    image = pkgs.fetchurl {
      url =
        "https://r4.wallpaperflare.com/wallpaper/212/579/800/graphic-design-fantasy-landscape-retro-wave-pixeles-wallpaper-68665dc800906cf8a0fc513e1882f4da.jpg";
      sha256 = pkgs.lib.fakeHash;
    };
    polarity = "dark";
  };
}
