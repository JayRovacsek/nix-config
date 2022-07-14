{ config, pkgs, flake ? { }, ... }:
let
  configs = {
    aarch64-darwin = import ./x86_64-darwin.nix;
    x86_64-darwin = import ./x86_64-darwin.nix;
    aarch64-linux = import ./aarch64-linux.nix { inherit config flake; };
    x86_64-linux = import ./x86_64-linux.nix { inherit config flake; };
  };

  extraOptions = ''
    experimental-features = nix-command flakes
  '';
in {
  nix = {
    inherit extraOptions;
    binaryCaches =
      [ "https://binarycache.rovacsek.com/" "https://microvm.cachix.org/" ];
    binaryCachePublicKeys = [
      "binarycache.rovacsek.com:xhZ1vkz2OQdHK/ex2ByA2GeziZoehrNHJCeMo7Afvr8="
      "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
    ];
  } // configs.${pkgs.system};
}
