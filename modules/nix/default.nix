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
      auto-optimise-store = pkgs.stdenv.isLinux;
      builders-use-substitutes = true;
      experimental-features = "nix-command flakes";
      http-connections = 0;
      sandbox = true;
      substituters = [ "https://binarycache.rovacsek.com/" ];
      trusted-public-keys = [
        "binarycache.rovacsek.com:xhZ1vkz2OQdHK/ex2ByA2GeziZoehrNHJCeMo7Afvr8="
      ];
      trusted-users = [
        "@wheel"
        "builder"
      ];
    };
  };
}
