{ config, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains generate-vhosts;

  service-name = "lidarr";

  domains = generate-domains { inherit config service-name; };

  virtualHosts = generate-vhosts {
    inherit config service-name;
    # port = config.services.lidarr.ports.http;
    port = 8686;
  };
in {
  # Extended options for nginx
  # TODO: map lidarr settings to custom options
  imports = [ ../../options/jellyfin ../../options/nginx ];
  services = {
    lidarr = {
      enable = true;
      openFirewall = true;
      # Below to be changed prior to deploy
      # group = "";
      # user = "";
      # dataDir = "/mnt/zfs/containers/lidarr";
    };

    nginx = {
      test = { inherit domains; };
      inherit virtualHosts;
    };
  };
}
