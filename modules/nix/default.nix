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
      sandbox = "relaxed";
      substituters = [
        "https://nixos-raspberrypi.cachix.org"
        "https://nix-community.cachix.org"
        "https://binarycache.rovacsek.com/"
      ];
      trusted-public-keys = [
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "binarycache.rovacsek.com:xhZ1vkz2OQdHK/ex2ByA2GeziZoehrNHJCeMo7Afvr8="
      ];
      trusted-users = [
        "@wheel"
        "builder"
      ];
    };
  };
}
