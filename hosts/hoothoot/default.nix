{ self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    container-guest
    nix-topology
    ntfy
    time
    timesyncd
  ];

  networking.hostName = "hoothoot";

  system.stateVersion = "26.05";
}
