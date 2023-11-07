{ config, ... }: {
  services.elasticsearch = {
    cluster_name = "elasticsearch";
    dataDir = "/mnt/zfs/logs/elasticsearch";
    enable = true;
    listenAddress = "0.0.0.0";
    # plugins = with pkgs.elasticsearchPlugins; [ search-guard ];
    port = 9200;
    restartIfChanged = true;
    single_node = true;
    tcp_port = 9300;
  };

  networking.firewall = {
    allowedTCPPorts = [ config.services.elasticsearch.tcp_port ];
    allowedUDPPorts = [ config.services.elasticsearch.port ];
  };

}
