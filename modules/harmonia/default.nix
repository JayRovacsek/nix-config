{
  config,
  lib,
  self,
  ...
}:
let
  inherit (self.common.networking.services) harmonia;
in
{
  age = {
    identityPaths = [ "/agenix/id-ed25519-nix-serve-primary" ];

    secrets."harmonia-priv-key.pem" = lib.mkForce {
      file = ../../secrets/nix-serve/cache-priv-key.pem.age;
      owner = "harmonia";
      mode = "0400";
    };
  };

  networking.firewall.allowedTCPPorts = [ harmonia.port ];

  nix.gc.automatic = lib.mkForce false;

  services.harmonia = {
    enable = true;
    # Refer to: https://github.com/nix-community/harmonia/?tab=readme-ov-file#harmonia
    settings = {
      bind = "[::]:${builtins.toString harmonia.port}";
      priority = 30;
      max_connection_rate = 256;
      workers = 8;
    };

    signKeyPath = config.age.secrets."harmonia-priv-key.pem".path;
  };
}
