{ self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    home-assistant
    container-guest
    nix-topology
    time
    timesyncd
  ];

  networking.hostName = "tentacruel";

  system.stateVersion = "24.11";
}
