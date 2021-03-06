{ config, flake, ... }:
let
  hardwareProfile = system:
    if builtins.hasAttr "profile" system.hardware.cpu then {
      inherit (system.hardware.cpu.profile) cores speed;
    } else {
      cores = 1;
      speed = 1;
    };

  # TODO: Make hostname here dynamic in relation to system tailscale configuration
  # rather than the networking hostname
  buildSystemFunction = system: {
    systems = [ system.nixpkgs.system ] ++ system.boot.binfmt.emulatedSystems;
    sshUser = "builder";
    sshKey = config.age.secrets."builder-id-ed25519".path;
    hostName = system.networking.hostName;
    supportedFeatures = system.nix.settings.system-features;
    # This is gross as it runs the code twice rather than once.
    # TODO: figure how to make it a single pass
    speedFactor = (builtins.mul ((hardwareProfile (system)).cores)
      ((hardwareProfile system).speed));
  };

  buildMachines = builtins.filter (x: x.speedFactor != 1)
    (builtins.map (host: buildSystemFunction host.config)
      (builtins.attrValues flake.nixosConfigurations));

in {
  age.secrets."builder-id-ed25519" = {
    file = ../../secrets/builder-id-ed25519.age;
    mode = "0400";
  };

  nix = {
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    settings = {
      trusted-users = [ "jay" "root" "builder" ];
      auto-optimise-store = true;
      sandbox = true;
    };
    distributedBuilds = true;

    settings = {
      substituters =
        [ "https://binarycache.rovacsek.com/" "https://microvm.cachix.org/" ];
      trusted-public-keys = [
        "binarycache.rovacsek.com:xhZ1vkz2OQdHK/ex2ByA2GeziZoehrNHJCeMo7Afvr8="
        "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
      ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    inherit buildMachines;
  };
}
