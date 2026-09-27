{ self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    bazarr
    container-guest
    nix-topology
    time
    timesyncd
  ];

  networking.hostName = "oddish";

  services.bazarr = {
    user = self.common.config.services.bazarr.users.bazarr.name;
    inherit (self.common.config.services.bazarr.users.bazarr) group;
  };

  system.stateVersion = "26.05";

  users = {
    inherit (self.common.config.services.bazarr) users;
    inherit (self.common.config.services.media) groups;
  };
}
