{ config, arch ? "x86_64-linux", flake ? { }, ... }: {

  imports = [ (import ./${arch}.nix { inherit config flake; }) ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      substituters =
        [ "https://binarycache.rovacsek.com/" "https://microvm.cachix.org/" ];
      trusted-public-keys = [
        "binarycache.rovacsek.com:xhZ1vkz2OQdHK/ex2ByA2GeziZoehrNHJCeMo7Afvr8="
        "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
      ];
    };
  };
}
