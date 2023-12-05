{ config, ... }: {
  networking.firewall = {
    allowedTCPPorts = [ config.services.koboldai.port ];
  };

  nix.settings = {
    substituters = [ "https://ai.cachix.org/" ];
    trusted-public-keys =
      [ "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc=" ];
  };

  services.koboldai = {
    enable = true;
    host = true;
    port = 5001;
  };
}
