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
    group = "media";
    user = "bazarr";
  };

  system.stateVersion = "24.11";

  users = {
    inherit (self.common.config.services.media) groups users;
  };
}
