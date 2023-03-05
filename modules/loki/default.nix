{
  services.loki = {
    enable = true;
    configuration = {

    };
    extraFlags = [ "" ];
    configFile = ./config.yml;
  };
}
