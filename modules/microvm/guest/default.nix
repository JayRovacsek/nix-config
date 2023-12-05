{ config, ... }:
let inherit (config.networking) hostName;
in {
  systemd.machineId = builtins.hashString "md5" config.networking.hostName;

  environment.etc."machine-id" = {
    mode = "0644";
    text = ''
      ${config.systemd.machineId}
    '';
  };

  networking.useNetworkd = true;

  microvm.shares = [
    {
      # On the host
      source = "/var/lib/microvms/${hostName}/journal";
      # In the MicroVM
      mountPoint = "/var/log/journal";
      tag = "journal";
      proto = "virtiofs";
      socket = "journal.sock";
    }
    {
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
      tag = "ro-store";
      proto = "virtiofs";
    }
  ];

  nix.settings = {
    substituters = [ "https://microvm.cachix.org/" ];
    trusted-public-keys =
      [ "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=" ];
  };

  systemd.network.networks."00-wired" = {
    enable = true;
    matchConfig.Name = "enp*";
    networkConfig.DHCP = "yes";
  };
}
