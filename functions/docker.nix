{ containerConfig, ... }: {
  "${containerConfig.serviceName}" = {
    image = containerConfig.image;
    ports = containerConfig.ports;
    volumes = containerConfig.volumes;
    environment = containerConfig.environment;
    extraOptions = containerConfig.extraOptions;
  };
}
