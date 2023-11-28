{ config, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains generate-vhosts;

  service-name = "jellyfin";

  domains = generate-domains { inherit config service-name; };

  virtualHosts = generate-vhosts {
    inherit config service-name;
    port = config.services.jellyfin.ports.http;
  };
in {
  # Extended options for jellyfin & nginx
  imports = [ ../../options/jellyfin ../../options/nginx ];

  services = {
    jellyfin = {
      enable = true;
      openFirewall = true;
      data-dir = null;
      cache-dir = null;
      metadata-dir = null;
      # Available, but useless to us as our settings already exist as default
      # dlna-settings = { };
      # encoding-settings = { };
      # logging-settings = { };
      # network-settings = { };
      # notification-settings = { };
      # system-settings = { };
      use-declarative-settings = true;
    };

    nginx = {
      test = { inherit domains; };
      inherit virtualHosts;
    };
  };
}
