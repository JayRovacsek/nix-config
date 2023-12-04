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
      inherit (config.nixpkgs) pkgs;
      test = config.services.nginx.test.enable;
      production = !config.services.nginx.test.enable;
      domains = generate-domains { inherit config service-name; };
      authelia-enabled =
        (lib.filterAttrs (_: v: v.enable) config.services.authelia.instances)
        != { };
    in genAttrs domains (domain:
      let
        self-signed = lib.findFirst (x: x.domain == domain) {
          keyPath = builtins.throw
            "services.nginx.test.enable is set to false - this throw should be impossible to hit";
          certificatePath = builtins.throw
            "services.nginx.test.enable is set to false - this throw should be impossible to hit";
        } config.services.nginx.test.certificateMap;

        authelia-location-conf = import ./authelia-location-conf.nix {
          inherit config pkgs production;
        };

        authelia-authrequest-conf = import ./authelia-request-conf.nix {
          inherit domain pkgs production;
        };

        proxy-conf = import ./proxy-conf.nix { inherit pkgs; };

        # The below code adds lines to the server block
        # if authelia is present, add required config options to the block
        serverExtraConfig =
          lib.optionalString (authelia-enabled && service-name != "authelia")
          "include ${authelia-location-conf};";

        locationExtraConfig = ''
          ${lib.optionalString authelia-enabled "include ${proxy-conf};"}
          ${lib.optionalString (authelia-enabled && service-name != "authelia")
          "include ${authelia-authrequest-conf};"}
        '';

      in recursiveUpdate {
        extraConfig = serverExtraConfig;
        forceSSL = true;
        sslCertificate = mkIf test self-signed.certificatePath;
        sslCertificateKey = mkIf test self-signed.keyPath;
        serverName = domain;
        locations."/" = {
          extraConfig = locationExtraConfig;

          # TODO: in the future having dynamic evaluation based - depends
          # on microvm & tailscale / overlay network
          proxyPass = "http://localhost:${builtins.toString port}";
          recommendedProxySettings = true;
        };
        useACMEHost = mkIf production domain;
      } overrides);
in { inherit generate-domains generate-vhosts; }
