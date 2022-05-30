{ config, pkgs, ... }:
let
  configs = { aarch64-darwin = import ./x86_64-darwin.nix; };
  configs = { x86_64-darwin = import ./x86_64-darwin.nix; };
  configs = { aarch64-linux = import ./x86_64-linux.nix; };
  configs = { x86_64-linux = import ./x86_64-linux.nix; };
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
