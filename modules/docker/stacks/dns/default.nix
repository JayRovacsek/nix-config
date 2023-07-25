{ config, ... }:
let
  inherit (config.flake.lib) docker etc user;

  piholeUserConfig = import ../../../../users/service-accounts/pihole.nix;
  piholeDockerConfig = import ../../configs/pihole.nix;

  # Config file contents to write to environment.etc locations
  local = import ./local.nix;
  cache = import ./cache.nix;

  # Files to write to etc
  etcConfigs =
    builtins.foldl' (x: y: x // (etc.generate-file { config = y; })) { } [
      local
      cache
    ];

  # Actual constructs used to generate useful config
  piholeUser = user.generate-service-user { userConfig = piholeUserConfig; };
  pihole = docker { containerConfig = piholeDockerConfig; };
in {
  virtualisation.oci-containers.containers = pihole;
  users.extraUsers = piholeUser.extraUsers;
  users.extraGroups = piholeUser.extraGroups;

  imports = [ ../../../stubby ];

  environment.etc = etcConfigs;

  networking.firewall.allowedTCPPorts = [ 53 80 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
