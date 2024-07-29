{ config, lib, self, ... }:
let
  # We use the below value as it'll be available before this
  # evaluates rather than self (which is available but
  # only after further evaluation)
  inherit (self.lib.distributed-builds) generate-system-ssh-extra-config;

  build-configs =
    builtins.fromJSON (builtins.readFile ../../static/build-machines.json);

  fast-configs = builtins.filter (cfg: cfg.speedFactor != 1) build-configs;

in {
  age.secrets."builder-id-ed25519" = {
    file = ../../secrets/ssh/builder-id-ed25519.age;
    mode = "0400";
  };

  programs.ssh.extraConfig = generate-system-ssh-extra-config fast-configs
    config.age.secrets.builder-id-ed25519.path;

  nix = {
    buildMachines = builtins.map
      (cfg: { sshKey = config.age.secrets."builder-id-ed25519".path; } // cfg)
      fast-configs;

    distributedBuilds = (builtins.length config.nix.buildMachines) != 0;

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      http-connections = 0;
      sandbox = true;
      substituters = [ "https://binarycache.rovacsek.com/" ];
      trusted-public-keys = [
        "binarycache.rovacsek.com:xhZ1vkz2OQdHK/ex2ByA2GeziZoehrNHJCeMo7Afvr8="
      ];
      trusted-users = [ "@wheel" "builder" ];
    };

    extraOptions = lib.concatStringsSep "\n" [
      "experimental-features = nix-command flakes"
      "builders-use-substitutes = true"
    ];
  };
}
