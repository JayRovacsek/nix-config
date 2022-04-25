{ nixpkgs, overlays, home-manager, nixos-hardware ? { } }:
let
  home-manager-function = import ../functions/home-manager.nix;

  x86_64-darwin = import nixpkgs {
    system = "x86_64-darwin";
    inherit overlays;
    config = { allowUnfree = true; };
  };
  system = "x86_64-darwin";
in {
  cloyster = let
    system = x86_64-darwin.system;
    pkgs = x86_64-darwin;
    modules = home-manager-function {
      inherit home-manager;
      host = "cloyster";
      isNixos = false;
    };
  in darwin.lib.darwinSystem {
    inherit system;
    inherit modules;
    #  = modules ++ [{
    #   nixpkgs.overlays =
    #     [ firefox-darwin.overlay nur.overlay my-overlays.dockutil ];
    # }];
  };
}
