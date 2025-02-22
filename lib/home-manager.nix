{ self }:
let
  # The signature of this function should match that of mainline HM:
  # https://github.com/nix-community/home-manager/blob/440faf5ae472657ef2d8cc7756d77b6ab0ace68d/flake.nix#L42
  # Ofc - don't use hyperlink above as it's static in reference :)
  fn =
    { pkgs, ... }:
    let
      inherit (self.inputs) home-manager;
      inherit (pkgs.stdenv) isLinux;

      base = {
        home-manager.useUserPackages = true;
      };

    in
    if isLinux then
      [
        base
        home-manager.nixosModules.default
      ]
    else
      [
        base
        home-manager.darwinModules.default
      ];
in
fn
