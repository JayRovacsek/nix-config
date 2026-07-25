{
  lib,
  self,
  ...
}:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    blocky
    buildbot-coordinator
    container-guest
    logging
    nix
    nix-topology
    remote-builds
    time
    timesyncd
  ];

  networking = {
    dhcpcd.enable = false;
    hostName = "magnemite";
    networkmanager.enable = false;
    useNetworkd = true;
  };

  # This is extremely important as this host does not utilise the
  # systemd networkd module, therefore not inheriting the
  # disabled resolved service.
  #
  # Blocky doesn't like that punk resolvd taking 53 off them
  services.resolved.enable = false;

  system.stateVersion = "25.05";

  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
}
