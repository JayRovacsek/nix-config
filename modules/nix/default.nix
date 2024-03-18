{ config, pkgs, self, ... }:
with builtins;
let
  # We use the below value as it'll be available before this
  # evaluates rather than self (which is available but
  # only after further evaluation)
  inherit (self.lib.distributed-builds) generate-system-ssh-extra-config;

  build-configs =
    builtins.fromJSON (builtins.readFile ../../static/build-machines.json);

  fast-configs = builtins.filter (cfg: cfg.speedFactor != 1) build-configs;

  buildMachines = builtins.map
    (cfg: { sshKey = config.age.secrets."builder-id-ed25519".path; } // cfg)
    fast-configs;

  distributedBuilds = (length buildMachines) != 0;

  extraConfig = generate-system-ssh-extra-config fast-configs
    config.age.secrets.builder-id-ed25519.path;

  gc = {
    automatic = false;
    options = "--delete-older-than 7d";
  };

  settings = {
    auto-optimise-store = true;
    sandbox = true;
    substituters = [ "https://binarycache.rovacsek.com/" ];
    trusted-public-keys = [
      "binarycache.rovacsek.com:xhZ1vkz2OQdHK/ex2ByA2GeziZoehrNHJCeMo7Afvr8="
    ];
    trusted-users = [ "@wheel" "builder" ];
  };

  extraOptions = ''
    experimental-features = nix-command flakes
    builders-use-substitutes = true
  '';

in {
  age.secrets."builder-id-ed25519" = {
    file = ../../secrets/ssh/builder-id-ed25519.age;
    mode = "0400";
  };

  programs.ssh = { inherit extraConfig; };

  nix = {
    inherit buildMachines distributedBuilds gc settings extraOptions;
    package = if builtins.hasAttr "nix-monitored" pkgs then
      pkgs.nix-monitored
    else
      pkgs.nix;
  };
}
