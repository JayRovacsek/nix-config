{ self, ... }:
{
  imports = with self.nixosModules; [
    ./authelia.nix
    agenix
    alloy
    authelia
    container-guest
    nginx
    nix-topology
    time
    timesyncd
  ];

  networking.hostName = "nidorino";

  services.nginx.statusPage = true;

  system.stateVersion = "24.05";
}
