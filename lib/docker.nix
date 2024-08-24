_: {
  generate-config = cfg: {
    "${cfg.serviceName}" = {
      inherit (cfg)
        autoStart
        image
        ports
        volumes
        environment
        extraOptions
        user
        ;
    };
  };
}
