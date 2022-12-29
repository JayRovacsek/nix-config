{ config, pkgs, flake, ... }: {
  inherit flake;

  age = {
    secrets."tailscale-dns-preauth-key" = {
      file = ../../secrets/tailscale/preauth-dns.age;
      mode = "0400";
    };
    identityPaths = [ "/agenix/id-ed25519-ssh-primary" ];
  };

  services.tailscale.tailnet = "admin";

  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./options.nix
    ./system-packages.nix
  ];

  networking = {
    hostName = "alakazam";
    hostId = "ef26b1be";
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
  };

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  system.stateVersion = "22.11";
}
