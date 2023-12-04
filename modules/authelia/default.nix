{ config, ... }: {
  services.authelia.instances.prod = {
    enable = true;

    settings = {
      default_2fa_method = "webauthn";
      log.level = "info";
      server.host = "0.0.0.0";
      telemetry.metrics.enabled = false;
      theme = "auto";
    };

    # TODO: Change this to currently used user & group
    # user = "";
    # group = "";
    settingsFiles = { };
    environmentVariables = { };
    secrets = {
      manual = false;
      storageEncryptionKeyFile =
        config.age.secrets.autheliaStorageEncryptionKeyFile.path;
      sessionSecretFile = config.age.secrets.autheliaSessionSecretFile.path;
      oidcIssuerPrivateKeyFile =
        config.age.secrets.autheliaOidcIssuerPrivateKeyFile.path;
      oidcHmacSecretFile = config.age.secrets.autheliaOidcHmacSecretFile.path;
      jwtSecretFile = config.age.secrets.autheliaJwtSecretFile.path;
    };
  };
}
