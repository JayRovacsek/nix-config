{ pkgs, self }:
pkgs.testers.runNixOSTest {
  name = "authelia-auth";

  nodes.machine =
    { config, pkgs, ... }:
    let
      # Custom Authelia configuration for the test environment
      # We need this because the default module uses hardcoded IPs/domains suitable for production/LAN
      # but not for this self-contained VM test.
      autheliaLocation = pkgs.callPackage ../packages/text/authelia-location-conf {
        inherit self;
        autheliaUrl = "http://127.0.0.1:9091/api/verify";
      };

      autheliaAuthRequest =
        pkgs.callPackage ../packages/text/authelia-authrequest-conf
          {
            domain = "authelia.test.rovacsek.com";
          };

      autheliaProxy = self.packages.${pkgs.system}.authelia-proxy-conf;
    in
    {
      imports = [
        self.nixosModules.authelia
        self.nixosModules.nginx
        self.nixosModules.prometheus
        ../options/modules/agenix/mock.nix
      ];

      config = {
        # Inject 'self' into specialArgs for modules that need it
        _module.args.self = self;

        # Define the mock secrets paths
        # We need to set 'path' for the secrets that authelia module expects
        age.secrets = {
          authelia-jwt-secret-key.path = pkgs.writeText "jwt" "random_jwt_secret_very_long_string_just_in_case_32_chars_at_least";
          authelia-session-secret-key.path = pkgs.writeText "session" "random_session_secret_very_long_string_just_in_case_32_chars_at_least";
          authelia-storage-encryption-key.path = pkgs.writeText "storage" "random_storage_key_very_long_string_just_in_case_32_chars_at_least";
          authelia-notifier-config.path = pkgs.writeText "notifier" ''
            notifier:
              filesystem:
                filename: /var/lib/authelia-test/notification.txt
          '';
          authelia-users.path = pkgs.writeText "users" ''
            users:
              testuser:
                displayname: "Test User"
                password: "$argon2id$v=19$m=65536,t=3,p=4$DnF1c2VybmFtZQ$DnF1c2VybmFtZQ"
                email: testuser@example.com
                groups:
                  - admins
          '';
        };

        # Basic networking
        networking = {
          hostName = "test-machine";
          firewall.enable = false;

          # Add a domain to /etc/hosts so we can resolve it
          hosts."127.0.0.1" = [
            "authelia.test.rovacsek.com"
            "prometheus-bypass.test.rovacsek.com"
            "prometheus-protected.test.rovacsek.com"
          ];
        };

        services = {
          nginx = {
            # Configure nginx to be test mode (authelia module uses this to switch to test config)
            test.enable = true;
            domains = [ "rovacsek.com" ];

            # Generate VirtualHost for Authelia
            virtualHosts =
              (self.lib.nginx.generate-vhosts {
                inherit config;
                subdomain = "authelia";
                overrides = {
                  locations."/".proxyPass = "http://127.0.0.1:9091";
                  enableAuthelia = false;
                };
              })
              // (self.lib.nginx.generate-vhosts {
                inherit config;
                subdomain = "prometheus-bypass";
                overrides = {
                  locations."/".proxyPass = "http://127.0.0.1:9092";
                  enableAuthelia = false;
                  extraConfig = "include ${autheliaLocation};";
                  locations."/".extraConfig =
                    "include ${autheliaProxy}; include ${autheliaAuthRequest};";
                };
              })
              // (self.lib.nginx.generate-vhosts {
                inherit config;
                subdomain = "prometheus-protected";
                overrides = {
                  locations."/".proxyPass = "http://127.0.0.1:9092";
                  enableAuthelia = false;
                  extraConfig = "include ${autheliaLocation};";
                  locations."/".extraConfig =
                    "include ${autheliaProxy}; include ${autheliaAuthRequest};";
                };
              });
          };

          # Fix for "access_control: 'default_policy' option 'deny' is invalid: when no rules are specified"
          authelia.instances.test.settings.access_control.rules = [
            {
              domain = "test.rovacsek.com";
              policy = "one_factor";
            }
            {
              domain = "prometheus-bypass.test.rovacsek.com";
              policy = "bypass";
            }
            {
              domain = "prometheus-protected.test.rovacsek.com";
              policy = "one_factor";
            }
          ];
        };

        # Trust the self-signed certificate in the test environment
        security.pki.certificateFiles = [ ];
      };
    };

  testScript = ''
    machine.wait_for_unit("nginx.service")
    machine.wait_for_unit("authelia-test.service")
    machine.wait_for_unit("prometheus.service")

    # Wait for nginx to listen
    machine.wait_for_open_port(443) # HTTPS only because generate-vhosts forces SSL
    machine.wait_for_open_port(9092)
    machine.wait_for_open_port(9091)

    # Verify Authelia is reachable via Nginx
    # Note: We expect a 200 OK because it's the login page, or a redirect.
    # Nginx handles SSL termination, so we talk HTTPS to it.

    # curl -k because self-signed certs
    # -v for verbose output in logs
    # -L to follow redirects (Authelia usually redirects to login)
    # Authelia is an SPA, so the title might be set by JS. We check for the root div or base href.
    machine.succeed("curl -k -v -L https://authelia.test.rovacsek.com | grep '<div id=\"root\"></div>'")

    # Test Bypass
    machine.succeed("curl -k -v -L https://prometheus-bypass.test.rovacsek.com | grep 'Prometheus'")

    # Test Protected
    # Should redirect to Authelia login
    machine.succeed("curl -k -v -L https://prometheus-protected.test.rovacsek.com | grep '<div id=\"root\"></div>'")
  '';
}
