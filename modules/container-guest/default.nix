{
  config,
  lib,
  self,
  ...
}:
{
  # Ensure a machine id exists and is stable on the host - this is required
  # to ensure consistent mount of the journald logs back to the host.
  #
  # When the container host provides a state directory bind-mount
  # (container-guest.stateBindMounts - see hosts/dragonite/containers.nix),
  # /etc/machine-id arrives via that mount and environment.etc must stay out
  # of the way: activation cannot replace a bind-mounted path with a symlink.
  environment.etc."machine-id" = lib.mkIf (!config.container-guest.stateBindMounts) {
    mode = "0644";
    text = ''
      ${config.systemd.machineId}
    '';
  };

  imports = [
    ../../options/modules/container-guest
    ../../options/modules/ssh
    ../../options/modules/systemd
  ];

  # Ensure we're using networkd & open ssh
  networking = {
    firewall.allowedTCPPorts = [ 22 ];
    useNetworkd = true;
    # Disable this - we want to leverage the DHCP responses
    # https://github.com/NixOS/nixpkgs/blob/84aceb4288d260c86c624ca926cd402557a6cf67/nixos/modules/virtualisation/container-config.nix#L26
    useHostResolvConf = false;
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
      # This is always the default within container settings:
      # https://github.com/NixOS/nixpkgs/blob/d233902339c02a9c334e7e593de68855ad26c4cb/nixos/modules/virtualisation/nixos-containers.nix#L60
      matchConfig.Name = "eth0";
      networkConfig.DHCP = "yes";
    };

    sleep.settings.Sleep = {
      AllowHibernation = "no";
      AllowSuspend = "no";
    };
  };

  services.openssh = {
    enable = true;
    # When the host has seeded a pinned host key (programs.ssh.hostKeyBase64),
    # point sshd at the bind-mounted key instead of letting sshd-keygen mint
    # a new one on every start.
    hostKeys = lib.mkIf (config.programs.ssh.hostKeyBase64 != null) [
      {
        type = "ed25519";
        path = "/etc/ssh/ssh_host_ed25519_key";
      }
    ];
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = self.common.config.services.openssh.public-keys;
}
