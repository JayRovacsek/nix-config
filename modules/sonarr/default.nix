{
  config,
  lib,
  self,
  ...
}:
let
  inherit (self.common.config.services.sonarr) port;
in
{
  # Extended options for sonarr
  imports = [ ../../options/sonarr ];

  age = {
    identityPaths = [ "/agenix/id-ed25519-sonarr-primary" ];

    secrets."sonarr-api-key" = lib.mkForce {
      file = ../../secrets/sonarr/api-key.age;
      owner = config.services.sonarr.user;
      mode = "0400";
    };
  };

  services.sonarr = {
    enable = true;
    api-key-file = config.age.secrets.sonarr-api-key.path;
    openPort = true;
    ports.http = port;
    use-declarative-settings = true;
  };
}
