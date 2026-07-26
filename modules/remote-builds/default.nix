{ config, self, ... }:
{
  imports = [
    ../../options/modules/networking
    ../../options/modules/remote-builds
    self.nixosModules.ssh
  ];

  age = {
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
