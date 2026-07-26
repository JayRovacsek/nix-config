{ self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    container-guest
    nix-topology
    sonarr
    time
    timesyncd
  ];

  networking.hostName = "bellsprout";

  services.sonarr = {
    user = self.common.config.services.sonarr.users.sonarr.name;
    inherit (self.common.config.services.sonarr.users.sonarr) group;
    authenticationMethod = "External";
  };

  system.stateVersion = "24.05";

  users = {
    inherit (self.common.config.services.sonarr) users;
    inherit (self.common.config.services.media) groups;
  };
}
