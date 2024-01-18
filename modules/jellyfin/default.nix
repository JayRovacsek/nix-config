{ config, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains generate-vhosts;

  service-name = "jellyfin";

  domains = generate-domains { inherit config service-name; };

  overrides = {
    locations = {
      "/" = { extraConfig = ""; };
      "~ (/jellyfin)?/socket" = {
        extraConfig = "";
        proxyPass = "http://localhost:${
            builtins.toString config.services.jellyfin.ports.http
          }";
      };
    };
  };

  virtualHosts = generate-vhosts {
    inherit config service-name overrides;
    port = config.services.jellyfin.ports.http;
  };
in {
  # Extended options for jellyfin & nginx
  imports = [ ../../options/jellyfin ../../options/nginx ];

  # TODO: add logic to ensure the unit loads _after_ zfs
  # mounts if they exist as they may be utilised.

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

      user = "media";
      group = "media";
    };

    nginx = {
      test = { inherit domains; };
      inherit virtualHosts;
    };
  };
}
