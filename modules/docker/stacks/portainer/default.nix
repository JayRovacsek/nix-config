{ config, ... }:
let
  inherit (config.flake.lib) docker;

  portainerUserConfig = import ../../../../users/service-accounts/portainer.nix;
  portainerDockerConfig = import ../../configs/portainer.nix;

  # Helper functions for generating correct nix configs
  userFunction = import ../../../../functions/service-user.nix;

  # Actual constructs used to generate useful config
  portainerUser = userFunction { userConfig = portainerUserConfig; };
  portainer = docker { containerConfig = portainerDockerConfig; };

in {
  virtualisation.oci-containers = { containers = portainer; };
  users.extraUsers = portainerUser.extraUsers;
  users.extraGroups = portainerUser.extraGroups;

  networking.firewall.allowedTCPPorts = [ 9000 ];
}
