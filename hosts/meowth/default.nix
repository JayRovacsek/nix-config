{ self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    container-guest
    nix-topology
    prowlarr
    time
    timesyncd
  ];

  networking.hostName = "meowth";

  system.stateVersion = "24.05";
}
