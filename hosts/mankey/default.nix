{ self, pkgs, ... }:
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
    user = self.common.config.services.deluge.users.deluge.name;
    inherit (self.common.config.services.deluge.users.deluge) group;
  };

  system.stateVersion = "24.05";

  users = {
    inherit (self.common.config.services.deluge) users;
    inherit (self.common.config.services.media) groups;
  };
}
