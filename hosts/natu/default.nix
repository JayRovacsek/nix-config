{ self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    anubis
    container-guest
    nix-topology
    time
    timesyncd
  ];

  networking.hostName = "natu";

  system.stateVersion = "26.05";
}
