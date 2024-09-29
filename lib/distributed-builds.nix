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
    host: generate-base-config host nixosConfigurations
  ) linux-suitable-hosts;

  darwin-suitable-hosts = builtins.filter (
    hostname:
    builtins.hasAttr "profile" darwinConfigurations.${hostname}.config.hardware.cpu
  ) darwin-host-identifiers;

  darwin-base-configs = builtins.map (
    host: generate-base-config host darwinConfigurations
  ) darwin-suitable-hosts;

  base-configs = linux-base-configs ++ darwin-base-configs;

  hardware-profile =
    system:
    if builtins.hasAttr "profile" system.hardware.cpu then
      { inherit (system.hardware.cpu.profile) cores speed; }
    else
      {
        cores = 1;
        speed = 1;
      };

  generate-base-config =
    hostname: parent-set:
    let
      inherit (parent-set.${hostname}) config;
      profile = hardware-profile config;
      inherit (config.nixpkgs) system;
    in
    {
      hostName = "${config.networking.hostName}.${
        config.networking.localDomain or "local"
      }";
      maxJobs = profile.cores;
      publicHostKey = config.programs.ssh.publicHostKeyBase64 or null;
      speedFactor = builtins.mul profile.cores profile.speed;
      sshUser = "builder";
      supportedFeatures = config.nix.settings.system-features or [ ];
      systems = [ system ] ++ (config.boot.binfmt.emulatedSystems or [ ]);
    };

  generate-system-ssh-extra-config =
    configs: identity-file:
    lib.concatStringsSep "\n\n" (
      builtins.map (cfg: ''
        Host ${cfg.hostName}
          HostName ${cfg.hostName}
          User ${cfg.sshUser}
          IdentitiesOnly yes
          ConnectTimeout 3
          StrictHostKeyChecking=accept-new
          IdentityFile ${identity-file}
      '') configs
    );

in
{
  inherit base-configs generate-base-config generate-system-ssh-extra-config;
}
