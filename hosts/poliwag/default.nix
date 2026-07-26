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
    user = self.common.config.services.radarr.users.radarr.name;
    inherit (self.common.config.services.radarr.users.radarr) group;
  };

  system.stateVersion = "24.05";

  users = {
    inherit (self.common.config.services.radarr) users;
    inherit (self.common.config.services.media) groups;
  };
}
