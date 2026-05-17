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
    group = "media";
    user = "media";
    authenticationMethod = "External";
  };

  system.stateVersion = "24.05";

  users = {
    inherit (self.common.config.services.media) groups users;
  };
}
