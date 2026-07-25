{
  config,
  pkgs,
  ...
}:
{
  nix = {
    distributedBuilds = (builtins.length config.nix.buildMachines) != 0;

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    settings = {
      allow-import-from-derivation = true;
      auto-optimise-store = pkgs.stdenv.isLinux;
      builders-use-substitutes = true;
      experimental-features = "nix-command flakes";
      http-connections = 0;
      sandbox = true;
      substituters = [
        "https://binarycache.rovacsek.com/"
        "https://nix-community.cachix.org"
        "https://nixos-raspberrypi.cachix.org"
      ];
      trusted-public-keys = [
        "binarycache.rovacsek.com:xhZ1vkz2OQdHK/ex2ByA2GeziZoehrNHJCeMo7Afvr8="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      ];
      trusted-users = [
        "@wheel"
        "builder"
      ];
    };
  };
}
