{ config, lib, self, ... }:
let
  inherit (self.lib) merge;

  port = 10080;

  prod = !config.services.nginx.test.enable;
in {
  age = {
    identityPaths = [ "/agenix/id-ed25519-acme-primary" ];

    secrets.acme-environment-file = {
      file = ../../secrets/acme/environment-file.age;
      mode = "0440";
      # As per magic value: https://github.com/NixOS/nixpkgs/blob/6df37dc6a77654682fe9f071c62b4242b5342e04/nixos/modules/security/acme/default.nix#L8
      owner = "acme";
      # Footgun if you wanted to create distinct capabilities around user/group for this.
      inherit (config.security.acme.defaults) group;
    };
  };

  networking.firewall.allowedTCPPorts = lib.mkIf prod [ port ];

  security.acme = lib.mkIf prod {
    acceptTerms = true;

    certs = merge (builtins.map (domain: {
      "${domain}" = {
        inherit domain;
        dnsProvider = "cloudflare";
        environmentFile = "${config.age.secrets.acme-environment-file.path}";
        extraDomainNames = [ "*.${domain}" ];
        reloadServices = [ "nginx" ];
        # Staging - use if testing, expect to see invalid certs however
        # server = "https://acme-staging-v02.api.letsencrypt.org/directory";
      };
    }) config.services.nginx.domains);

    defaults = {
      inherit (config.services.nginx) group;
      email = "acme@rovacsek.com";
    };
  };
}
