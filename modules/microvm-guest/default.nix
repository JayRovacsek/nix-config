{ config, ... }: {
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
      source = "/var/lib/microvms/${config.networking.hostName}/journal";
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

  systemd.network.networks."00-wired" = {
    enable = true;
    matchConfig.Name = "enp*";
    networkConfig.DHCP = "yes";
  };
}
