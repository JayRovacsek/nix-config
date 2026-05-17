{ self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    flaresolverr
    container-guest
    nix-topology
    time
    timesyncd
  ];

  networking.hostName = "slowpoke";

  system.stateVersion = "24.05";
}
