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
    group = "media";
    user = "media";
  };

  system.stateVersion = "24.05";

  users = {
    inherit (self.common.config.services.media) groups users;
  };
}
