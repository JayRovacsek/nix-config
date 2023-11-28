{ self }:
let
  inherit (self.inputs.nixpkgs) lib;
  inherit (lib) genAttrs mkIf optionalString recursiveUpdate;

  generate-domains = { config, service-name }:
    builtins.map (domain:
      "${service-name}.${
        lib.optionalString config.services.nginx.test.enable "test."
      }${domain}") config.services.nginx.domains;

  generate-vhosts = { config, service-name, port, overrides ? { }, ... }:
    let
      test = config.services.nginx.test.enable;
      prod = !config.services.nginx.test.enable;
      domains = generate-domains { inherit config service-name; };

    in genAttrs domains (domain:
      let
        self-signed = lib.findFirst (x: x.domain == domain) {
          keyPath = builtins.throw
            "services.nginx.test.enable is set to false - this throw should be impossible to hit";
          certificatePath = builtins.throw
            "services.nginx.test.enable is set to false - this throw should be impossible to hit";
        } config.services.nginx.test.certificateMap;

      in recursiveUpdate {
        forceSSL = true;
        sslCertificate = mkIf test self-signed.certificatePath;
        sslCertificateKey = mkIf test self-signed.keyPath;
        serverName = domain;
        locations."/" = {
          proxyPass = "http://localhost:${builtins.toString port}";
          recommendedProxySettings = true;
        };
        useACMEHost = mkIf prod domain;
      } overrides);
in { inherit generate-domains generate-vhosts; }
