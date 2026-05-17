{ self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    container-guest
    nix-topology
    radarr
    time
    timesyncd
  ];

  networking.hostName = "poliwag";

  services.radarr = {
    group = "media";
    user = "media";
  };

  system.stateVersion = "24.05";

  users = {
    inherit (self.common.config.services.media) groups users;
  };
}
