{ self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    container-guest
    nix-topology
    valheim
    time
    timesyncd
  ];

  networking.hostName = "porygon";

  system.stateVersion = "24.05";

}
