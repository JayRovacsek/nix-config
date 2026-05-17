{ self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    headscale
    container-guest
    nix-topology
    time
    timesyncd
  ];

  age.identityPaths = [ "/agenix/id-ed25519-magikarp-primary" ];

  networking.hostName = "magikarp";

  system.stateVersion = "24.05";
}
