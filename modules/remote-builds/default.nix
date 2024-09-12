{ config, ... }:
{
  imports = [ ../../options/modules/remote-builds ];

  age = {
    identityPaths = [
      "/agenix/id-ed25519-ssh-primary"
    ];
    secrets.builder-id-ed25519 = {
      file = ../../secrets/ssh/builder-id-ed25519.age;
      mode = "0400";
    };
  };

  remoteBuilds = {
    enable = true;
    sshKey = config.age.secrets.builder-id-ed25519.path;
    machineConfigs = ./machines.json;
  };
}
