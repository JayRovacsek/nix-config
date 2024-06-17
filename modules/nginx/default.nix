{ ... }: {
  # Extended options for nginx
  imports = [ ../../options/nginx ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services = {
    nginx = {
      enable = true;
      enableReload = true;
      recommendedTlsSettings = true;
      recommendedZstdSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedBrotliSettings = true;
    };

    prometheus.exporters.nginx.enable = true;
  };
}
