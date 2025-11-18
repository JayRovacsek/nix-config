{
  pkgs,
  lib,
  # osConfig,
  self,
  ...
}:
{
  nixpkgs = {
    config.permittedInsecurePackages = [
      "electron-36.9.5"
      "qtwebengine-5.15.19"
    ];
    overlays = [
      self.overlays.jellyfin-wayland
    ];
  };

  home.packages =
    (lib.optionals pkgs.stdenv.isLinux (
      with pkgs;
      [
        brave

        # Productivity
        gimp

        # Communication
        signal-desktop
      ]
    ))
    ++ (lib.optionals pkgs.stdenv.isDarwin [

    ]);
}
