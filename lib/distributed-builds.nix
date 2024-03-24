{ self }:
let
  inherit (self) nixosConfigurations darwinConfigurations;
  inherit (self.common.metadata) darwin-host-identifiers linux-host-identifiers;
  inherit (self.inputs.nixpkgs) lib;

  linux-suitable-hosts = builtins.filter (hostname:
    builtins.hasAttr "profile"
    nixosConfigurations.${hostname}.config.hardware.cpu) linux-host-identifiers;

  linux-base-configs =
    builtins.map (host: generate-base-config host nixosConfigurations)
    linux-suitable-hosts;

  darwin-suitable-hosts = builtins.filter (hostname:
    builtins.hasAttr "profile"
    darwinConfigurations.${hostname}.config.hardware.cpu)
    darwin-host-identifiers;

  darwin-base-configs =
    builtins.map (host: generate-base-config host darwinConfigurations)
    darwin-suitable-hosts;

  base-configs = linux-base-configs ++ darwin-base-configs;

  hardware-profile = system:
    if builtins.hasAttr "profile" system.hardware.cpu then {
      inherit (system.hardware.cpu.profile) cores speed;
    } else {
      cores = 1;
      speed = 1;
    };

  generate-base-config = hostname: parent-set:
    let
      system = parent-set.${hostname}.config;
      emulated-systems = lib.optionals (builtins.hasAttr "boot" system)
        system.boot.binfmt.emulatedSystems;
    in {
      systems = [ system.nixpkgs.system ] ++ emulated-systems;
      maxJobs = (hardware-profile system).cores;
      sshUser = "builder";

      # WARNING: pretty big assumption that localDomain exists on the target system plus
      # assumption we are using "local" as local domain identifier.
      # This is only temporary until we get into tailscale as the transport mechanism here
      hostName = "${system.networking.hostName}.${
          if builtins.hasAttr "localDomain" system.networking then
            system.networking.localDomain
          else
            "local"
        }";
      # If we don't have the system-features attribute, we know
      supportedFeatures =
        if builtins.hasAttr "system-features" system.nix.settings then
          system.nix.settings.system-features
        else
          [ ];
      # This is gross as it runs the code twice rather than once.
      # TODO: figure how to make it a single pass
      speedFactor = let inherit (hardware-profile system) cores speed;
      in builtins.mul cores speed;
    };

  generate-system-ssh-extra-config = configs: identity-file:
    lib.concatStringsSep "\n\n" (builtins.map (cfg: ''
      Host ${cfg.hostName}
        HostName ${cfg.hostName}
        User ${cfg.sshUser}
        IdentitiesOnly yes
        ConnectTimeout 3
        StrictHostKeyChecking=accept-new
        IdentityFile ${identity-file}
    '') configs);

in {
  inherit base-configs generate-base-config generate-system-ssh-extra-config;
}
