{ config, ... }:
let
  inherit (config.flake.lib) docker user;

  portainerUserConfig = import ../../../../users/service-accounts/portainer.nix;
  portainerDockerConfig = import ../../configs/portainer.nix;

  # Actual constructs used to generate useful config
  portainerUser =
    user.generate-service-user { userConfig = portainerUserConfig; };
  portainer = docker { containerConfig = portainerDockerConfig; };

in {
  virtualisation.oci-containers = { containers = portainer; };
  users.extraUsers = portainerUser.extraUsers;
  users.extraGroups = portainerUser.extraGroups;

  networking.firewall.allowedTCPPorts = [ 9000 ];
}
