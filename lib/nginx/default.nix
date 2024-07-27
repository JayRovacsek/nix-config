{ self }:
let
  inherit (self.inputs.nixpkgs) lib;
  inherit (lib) genAttrs mkIf optionalString recursiveUpdate;

  generate-domains = { config, subdomain }:
    builtins.map (domain:
      "${subdomain}.${
        lib.optionalString config.services.nginx.test.enable "test."
      }${domain}") config.services.nginx.domains;

  generate-vhosts = { config, subdomain, overrides ? { }, ... }:
    let
      test = config.services.nginx.test.enable;
      production = !config.services.nginx.test.enable;
      domains = generate-domains { inherit config subdomain; };
    in genAttrs domains (domain:
      let
        root = lib.findFirst (x: lib.hasSuffix x domain) ""
          config.services.nginx.domains;

        self-signed = lib.findFirst (x: x.domain == domain) {
          keyPath = builtins.throw
            "services.nginx.test.enable is set to false - this throw should be impossible to hit";
          certificatePath = builtins.throw
            "services.nginx.test.enable is set to false - this throw should be impossible to hit";
        } config.services.nginx.test.certificateMap;

      in recursiveUpdate {
        forceSSL = true;
        kTLS = true;
        serverName = domain;
        sslCertificate = mkIf test self-signed.certificatePath;
        sslCertificateKey = mkIf test self-signed.keyPath;
        useACMEHost = mkIf production root;
      } overrides);
in { inherit generate-domains generate-vhosts; }
