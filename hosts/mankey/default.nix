{ self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    deluge
    container-guest
    nix-topology
    time
    timesyncd
  ];

  networking.hostName = "mankey";

  services.deluge = {
    config.download_location = "/srv/downloads";
    user = "media";
    group = "media";
  };

  system.stateVersion = "24.05";

  users = {
    inherit (self.common.config.services.media) groups users;
  };
}
