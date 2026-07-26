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
    # https://github.com/NixOS/nixpkgs/issues/540545
    # TODO: remove once fixed upstream
    package = pkgs.deluge.overrideAttrs (old: {
      propagatedBuildInputs =
        pkgs.lib.remove pkgs.python3Packages.setuptools old.propagatedBuildInputs
        ++ [ pkgs.python3Packages.setuptools_80 ];
    });
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
