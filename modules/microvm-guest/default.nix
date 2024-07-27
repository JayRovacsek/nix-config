{ config, lib, self, microvm ? false, ... }:
let
  # Agenix is likely required if we have a share from host to guest passing
  # a secret and identity paths has some kind of value.
  agenix-required = config.age.identityPaths != [ ];
in {
  # Ensure a machine id exists and is stable on the host - this is required
  # to ensure consistent mount of the journald logs back to the host
  environment.etc."machine-id" = {
    mode = "0644";
    text = ''
      ${config.systemd.machineId}
    '';
  };

  # This means the filesystem will be mounted prior to agenix attempting to 
  # decrypt secrets with associated keys - otherwise agenix will error as it
  # runs far earlier than when the mount will occur
  # See also: https://github.com/ryantm/agenix/issues/45
  fileSystems = {
    "/var/lib".neededForBoot = true;
  } // lib.optionalAttrs agenix-required { "/agenix".neededForBoot = true; };

  imports = [ ../../options/systemd ]
    ++ (lib.optionals (!microvm) [ self.inputs.microvm.nixosModules.microvm ]);

  microvm.shares = (lib.optionals agenix-required [{
    # On the host
    source = "/agenix/${config.systemd.machineId}";
    # In the MicroVM
    mountPoint = "/agenix";
    tag = "secrets";
    proto = "virtiofs";
  }]) ++ [
    # 
    {
      # On the host
      source = "/var/lib/${config.systemd.machineId}";
      # In the MicroVM
      mountPoint = "/var/lib";
      tag = "application-persistence";
      proto = "virtiofs";
    }
    # Pass journald logs back to the host as per 
    # https://astro.github.io/microvm.nix/faq.html#how-to-centralize-logging-with-journald
    {
      # On the host
      source = "/var/lib/microvms/${config.networking.hostName}/journal";
      # In the MicroVM
      mountPoint = "/var/log/journal";
      tag = "journal";
      proto = "virtiofs";
      socket = "journal.sock";
    }
    # Provide a copy of the host's nix store
    # TODO: consider removing this as it means a compromised
    # guest could see and understand more about the host it exists
    # within
    {
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
      tag = "ro-store";
      proto = "virtiofs";
    }
  ];

  # Ensure we're using networkd & open ssh
  networking = {
    firewall.allowedTCPPorts = [ 22 ];
    useNetworkd = true;
  };

  # Disable power management options
  powerManagement.enable = false;

  systemd = {
    # Blunt approach to ensuring stable machine id.
    # TODO: review if there might be a better method to generating this
    # however this is likely not problematic while duplicate host names 
    # are unlikely to exist within an environment.
    machineId = builtins.hashString "md5" config.networking.hostName;

    # Very basic config asking for DHCP via eth interfaces
    network.networks."00-wired" = {
      enable = true;
      matchConfig.Name = "enp*";
      networkConfig.DHCP = "yes";
    };

    sleep.extraConfig = ''
      AllowHibernation=no
      AllowSuspend=no
    '';
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys =
    self.common.networking.services.openssh.public-keys;
}
