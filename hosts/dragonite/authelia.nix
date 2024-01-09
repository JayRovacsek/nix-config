{ config, lib, ... }:
let
  inherit (config.flake.lib.authelia)
    generate-prod-access-rules generate-test-access-rules;

  services = lib.unique [
    "deluge"
    "lidarr"
    "pfsense"
    "portainer"
    "prowlarr"
    "radarr"
    "sonarr"
  ];

in {
  services = {
    authelia.instances = builtins.foldl' (acc: service-name:
      let
        prod-access-rules =
          generate-prod-access-rules config.services.nginx.domains service-name;
        test-access-rules =
          generate-test-access-rules config.services.nginx.domains service-name;
      in {
        production.settings.access_control.rules =
          acc.production.settings.access_control.rules ++ prod-access-rules;
        test.settings.access_control.rules =
          acc.production.settings.access_control.rules ++ test-access-rules;
      }) {
        production.settings.access_control.rules = [ ];
        test.settings.access_control.rules = [ ];
      } services;
  };
}
