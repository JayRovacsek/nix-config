# This module assumes the existence of a suitably generated keypair
# To generate this, either follow the instructions here: https://nixos.wiki/wiki/Binary_Cache
{ config, lib, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains generate-vhosts;

  service-name = "binarycache";

  overrides = {
    locations."/".extraConfig = ''
      allow 10.0.0.0/8;
      allow 172.16.0.0/12;
      allow 192.168.0.0/16;
      deny all;
    '';
  };

  domains = generate-domains { inherit config service-name; };

  virtualHosts = generate-vhosts {
    inherit config service-name overrides;
    inherit (config.services.nix-serve) port;
  };
in {
  age = {
    identityPaths = [ "/agenix/id-ed25519-nix-serve-primary" ];

    secrets."cache-priv-key.pem" = lib.mkForce {
      file = ../../secrets/nix-serve/cache-priv-key.pem.age;
      owner = "nix-serve";
      mode = "0400";
    };
  };

  services = {
    nginx = {
      test = { inherit domains; };
      inherit virtualHosts;
    };

    nix-serve = {
      enable = true;
      secretKeyFile = config.age.secrets."cache-priv-key.pem".path;
      # The port is just the same as default, but included here to ensure documentation of
      # the value
      port = 5000;
      openFirewall = true;
    };
  };
}
