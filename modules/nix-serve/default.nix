# This module assumes the existence of a suitably generated keypair
# To generate this, either follow the instructions here: https://nixos.wiki/wiki/Binary_Cache
{
  config,
  lib,
  self,
  ...
}:
{
  age = {
    identityPaths = [ "/agenix/id-ed25519-nix-serve-primary" ];

    secrets."cache-priv-key.pem" = lib.mkForce {
      file = ../../secrets/nix-serve/cache-priv-key.pem.age;
      owner = "nix-serve";
      mode = "0400";
    };
  };

  nix.gc.automatic = lib.mkForce false;

  services.nix-serve = {
    enable = true;
    openFirewall = true;
    secretKeyFile = config.age.secrets."cache-priv-key.pem".path;

    inherit (self.common.networking.services.binarycache) port;
  };
}
