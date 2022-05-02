{ config, pkgs, ... }:
let
  configs = { x86_64-darwin = import ./x86_64-darwin.nix; };
  configs = { x86_64-linux = import ./x86_64-linux.nix; };
  configs = { aarch64-linux = import ./x86_64-linux.nix; };
  extraOptions = ''
    experimental-features = nix-command flakes
  '';
  package = pkgs.nixUnstable;
in {
  nix = {
    inherit package;
    inherit extraOptions;
    binaryCaches = [ "https://binarycache.rovacsek.com" ];
    binaryCachePublicKeys = [
      "binarycache.rovacsek.com:xhZ1vkz2OQdHK/ex2ByA2GeziZoehrNHJCeMo7Afvr8="
    ];
  } // configs.${pkgs.system};
}
