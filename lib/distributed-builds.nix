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

  base-configs = lib.flatten (linux-base-configs ++ darwin-base-configs);

  hardware-profile =
    system:
    if builtins.hasAttr "profile" system.hardware.cpu then
      { inherit (system.hardware.cpu.profile) cores speed; }
    else
      {
        cores = 1;
        speed = 1;
      };

  generate-base-configs =
    hostname: parent-set:
    let
      inherit (parent-set.${hostname}) config;
      profile = hardware-profile config;
      inherit (config.nixpkgs) system;
      ips = self.common.config.hosts.${hostname}.ips or [ ];
      unique-ips = lib.unique (builtins.map (x: x.address) ips);
      speedFactor = builtins.mul profile.cores profile.speed;
    in
    if speedFactor == 1 then
      [ ]
    else
      [
        {
          hostName = "${config.networking.hostName}.${
            config.networking.localDomain or "local"
          }";
          maxJobs = profile.cores;
          protocol = "ssh";
          publicHostKey = config.programs.ssh.publicHostKeyBase64 or null;
          inherit speedFactor;
          sshUser = "builder";
          supportedFeatures = config.nix.settings.system-features or [ ];
          systems = [ system ] ++ (config.boot.binfmt.emulatedSystems or [ ]);
        }
      ]
      ++ builtins.map (ip: {
        hostName = ip;
        maxJobs = profile.cores;
        protocol = "ssh";
        publicHostKey = config.programs.ssh.publicHostKeyBase64 or null;
        inherit speedFactor;
        sshUser = "builder";
        supportedFeatures = config.nix.settings.system-features or [ ];
        systems = [ system ] ++ (config.boot.binfmt.emulatedSystems or [ ]);
      }) unique-ips;

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
  inherit base-configs generate-base-configs generate-system-ssh-extra-config;
}
