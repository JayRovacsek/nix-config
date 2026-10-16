{ self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    container-guest
    nix-topology
    time
    timesyncd
  ];

  networking.hostName = "porygon";

  system.stateVersion = "26.05";

}
