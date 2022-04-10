{ containerConfig, ... }: {
  "${containerConfig.serviceName}" = {
    autoStart = containerConfig.autoStart;
    image = containerConfig.image;
    ports = containerConfig.ports;
    volumes = containerConfig.volumes;
    environment = containerConfig.environment;
    extraOptions = containerConfig.extraOptions;
    # user = containerConfig.user;
  };
}
