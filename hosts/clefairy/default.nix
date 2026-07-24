{ self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    container-guest
    nix-topology
    time
    timesyncd
    unifi
  ];

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "clefairy";

  system.stateVersion = "26.05";
}
