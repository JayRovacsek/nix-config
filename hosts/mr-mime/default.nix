{ self, ... }:
{
  age.identityPaths = [
    "/agenix/id-ed25519-mr-mime-primary"
  ];

  imports = with self.nixosModules; [
    agenix
    alloy
    grafana
    loki
    container-guest
    nix-topology
    prometheus
    time
    timesyncd
  ];

  networking.hostName = "mr-mime";

  services.grafana.settings.server.root_url = "https://grafana.rovacsek.com";

  system.stateVersion = "24.05";
}
