_: {
  generate-config = { containerConfig, ... }: {
    "${containerConfig.serviceName}" = {
      inherit (containerConfig)
        autoStart image ports volumes environment extraOptions user;
    };
  };
}
