{
  pkgs,
  lib,
  # osConfig,
  self,
  ...
}:
{
  nixpkgs.overlays = [
    self.overlays.jellyfin-wayland
  ];

  home.packages =
    (lib.optionals pkgs.stdenv.isLinux (
      with pkgs;
      [
        brave

        # Productivity
        gimp
        jellyfin-media-player-wayland

        # Communication
        signal-desktop
      ]
    ))
    ++ (lib.optionals pkgs.stdenv.isDarwin [

    ]);
}
