{ config, pkgs, ... }: {
  # As per: https://opensearch.org/docs/latest/quickstart/
  # Not honouring the suggestion for the below simply due to default
  # nixos being 4x the recommended
  # boot.kernel.sysctl."vm.max_map_count" = 262144;

  networking.firewall = {
    allowedTCPPorts = [
      config.services.opensearch.settings."http.port"
      config.services.opensearch.settings."transport.port"
    ];
  };

  services.opensearch = {
    enable = true;
    extraCmdLineOptions = [ ];
    extraJavaOptions = [ ];
    logging = ''
      logger.action.name = org.opensearch.action
      logger.action.level = info

      appender.console.type = Console
      appender.console.name = console
      appender.console.layout.type = PatternLayout
      appender.console.layout.pattern = [%d{ISO8601}][%-5p][%-25c{1.}] %marker%m%n

      rootLogger.level = info
      rootLogger.appenderRef.console.ref = console
    '';
    package = pkgs.opensearch;
    restartIfChanged = true;
    settings = {
      "cluster.name" = "opensearch";
      "discovery.type" = "single-node";
      "http.port" = 9200;
      "network.host" = "127.0.0.1";
      "transport.port" = 9300;
    };
  };
}
