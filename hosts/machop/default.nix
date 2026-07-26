{ self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    lidarr
    container-guest
    nix-topology
    time
    timesyncd
  ];

  networking.hostName = "machop";

  services.lidarr = {
    user = self.common.config.services.lidarr.users.lidarr.name;
    inherit (self.common.config.services.lidarr.users.lidarr) group;
  };

  system.stateVersion = "24.05";

  users = {
    inherit (self.common.config.services.lidarr) users;
    inherit (self.common.config.services.media) groups;
  };
}
