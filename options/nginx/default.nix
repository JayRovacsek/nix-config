{ config, lib, pkgs, ... }:
let
  inherit (config.flake.lib) certificates;
  inherit (certificate-lib) generate-self-signed;

  certificate-lib = certificates pkgs;
  cfg = config.services.nginx;

in with lib; {
  options.services.nginx = {
    domains = mkOption {
      description = ''
        Domains to generate mappings for
      '';
      default = [ ];
      type = with types; listOf str;
    };
    test = {
      enable = mkOption {
        type = with types; bool;
        default = false;
        description =
          "If the certificate and subsequent acme utilisation should be in test mode (self signed and deterministic) or not";
      };

      domains = mkOption {
        description = ''
          Mapping of domains to certificates based on the services.nginx.test.domains property
        '';
        default = [ "localdomain" ];
        type = with types; listOf str;
      };

      certificateMap = mkOption {
        description = ''
          Mapping of domains to certificates based on the services.nginx.test.domains property
        '';
        type = with types;
          listOf (submodule {
            options = {
              domain = mkOption { type = str; };
              certificatePath = mkOption { type = str; };
              keyPath = mkOption { type = str; };
            };
          });
      };
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      test = mkIf cfg.test.enable {
        domains = builtins.map (x: "test.${x}") cfg.domains;

        certificateMap = builtins.map (domain:
          let cert = generate-self-signed domain;
          in {
            inherit domain;
            certificatePath = "${cert}/share/self-signed.crt";
            keyPath = "${cert}/share/privkey.key";
          }) cfg.test.domains;
      };
    };
  };
}
