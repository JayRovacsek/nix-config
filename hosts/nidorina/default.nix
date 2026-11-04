{ self, ... }:
{
  imports =
    (with self.nixosModules; [
      acme
      agenix
      alloy
      ddclient
      container-guest
      nginx
      nix-topology
      time
      timesyncd
      tmp-tmpfs
    ])
    ++ [ ./nginx.nix ];

  networking.hostName = "nidorina";

  system.stateVersion = "24.05";
}
