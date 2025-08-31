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
        feishin

        # Communication
        signal-desktop
      ]
    ))
    ++ (lib.optionals pkgs.stdenv.isDarwin [

    ]);
}
