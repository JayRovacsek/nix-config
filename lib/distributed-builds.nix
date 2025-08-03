{ self }:
let
  inherit (self) nixosConfigurations darwinConfigurations;
  inherit (self.common.metadata) darwin-host-identifiers linux-host-identifiers;
  inherit (self.inputs.nixpkgs) lib;

  linux-suitable-hosts = builtins.filter (
    hostname:
    builtins.hasAttr "profile" nixosConfigurations.${hostname}.config.hardware.cpu
  ) linux-host-identifiers;

  linux-base-configs = builtins.map (
    host: generate-base-configs host nixosConfigurations
  ) linux-suitable-hosts;

  darwin-suitable-hosts = builtins.filter (
    hostname:
    builtins.hasAttr "profile" darwinConfigurations.${hostname}.config.hardware.cpu
  ) darwin-host-identifiers;

  darwin-base-configs = builtins.map (
    host: generate-base-configs host darwinConfigurations
  ) darwin-suitable-hosts;

  base-configs = builtins.filter (cfg: cfg.speedFactor > 1) (
    lib.flatten (linux-base-configs ++ darwin-base-configs)
  );

  hardware-profile =
    system:
    if builtins.hasAttr "profile" system.hardware.cpu then
      { inherit (system.hardware.cpu.profile) cores speed; }
    else
      {
        cores = 1;
        speed = 1;
      };

  # Only ssh-ng configurations are generated, if ssh type is needed, we should explicitly
  # define this in the remote builds option. However ssh as a type is realistically an
  # antipattern as it requires manual changes on the target environments to work unlike ssh-ng
  generate-base-configs =
    hostname: parent-set:
    let
      inherit (parent-set.${hostname}) config;
      profile = hardware-profile config;
      inherit (config.nixpkgs) system;
    in
    [
      {
        hostName = "${config.networking.hostName}.${
          config.networking.localDomain or "local"
        }";
        maxJobs = profile.cores;
        protocol = "ssh-ng";
        publicHostKey = config.programs.ssh.publicHostKeyBase64 or null;
        speedFactor = builtins.ceil (builtins.mul profile.cores profile.speed / 2);
        sshUser = "builder";
        supportedFeatures = config.nix.settings.system-features or [ ];
        systems = [ system ] ++ (config.boot.binfmt.emulatedSystems or [ ]);
      }
    ];
in
{
  inherit base-configs generate-base-configs;
}
