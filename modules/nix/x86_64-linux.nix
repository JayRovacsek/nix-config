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
    hostName = system.networking.hostName;
    supportedFeatures = system.nix.systemFeatures;
    # This is gross as it runs the code twice rather than once.
    # TODO: figure how to make it a single pass
    speedFactor = (builtins.mul ((hardwareProfile (system)).cores)
      ((hardwareProfile (system)).speed));
  };

  buildMachines = builtins.map (host: buildSystemFunction host.config)
    (builtins.attrValues flake.nixosConfigurations);

in {
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

  inherit buildMachines;
}
