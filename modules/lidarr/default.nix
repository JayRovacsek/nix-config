{ config, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains generate-vhosts;

  service-name = "lidarr";

  port = 8686;

  domains = generate-domains { inherit config service-name; };

  overrides.locations."~ (/lidarr)?/api" = {
    extraConfig = "";
    proxyPass = "http://localhost:${builtins.toString port}";
  };

  virtualHosts =
    generate-vhosts { inherit config overrides port service-name; };
in {
  # Extended options for nginx
  # TODO: map lidarr settings to custom options
  imports = [ ../../options/nginx ];

  services = {
    lidarr = {
      enable = true;
      openFirewall = true;
    };

    nginx = {
      test = { inherit domains; };
      inherit virtualHosts;
    };
  };
}
