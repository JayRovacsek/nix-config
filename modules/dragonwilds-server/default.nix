{ config, self, ... }: {
  imports = [
    ../../options/modules/dragonwilds-server
    self.nixosModules.agenix
  ];

  age.secrets.dragonwilds-server-config.file = ../../secrets/dragonwilds/server-config-file.age;

  nixpkgs.config.allowUnfree = true;

  services.dragonwilds-server = {
    enable = true;
    serverConfig = config.age.secrets.dragonwilds-server-config.path;
  };
}
