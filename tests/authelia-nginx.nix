{ pkgs, self }:
let
  inherit (pkgs) lib;
in
pkgs.testers.runNixOSTest {
  name = "authelia-nginx";

  nodes.machine =
    { config, pkgs, ... }:
    let
      # Custom Authelia configuration for the test environment
      # We need this because the default module uses hardcoded IPs/domains suitable for production/LAN
      # but not for this self-contained VM test.
      autheliaLocation = pkgs.writeText "authelia-location.conf" ''
        location /authelia {
            internal;
            set $upstream_authelia http://127.0.0.1:9091/api/verify;
            proxy_pass $upstream_authelia;
            proxy_pass_request_body off;
            proxy_set_header Content-Length "";
            proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
            proxy_set_header X-Original-Method $request_method;
            proxy_set_header X-Forwarded-Method $request_method;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_set_header X-Forwarded-Uri $request_uri;
            proxy_set_header X-Forwarded-For $remote_addr;
        }
      '';

      autheliaAuthRequest = pkgs.writeText "authelia-authrequest.conf" ''
        auth_request /authelia;
        set $target_url $scheme://$http_host$request_uri;
        auth_request_set $user $upstream_http_remote_user;
        auth_request_set $groups $upstream_http_remote_groups;
        auth_request_set $name $upstream_http_remote_name;
        auth_request_set $email $upstream_http_remote_email;
        proxy_set_header Remote-User $user;
        proxy_set_header Remote-Groups $groups;
        proxy_set_header Remote-Name $name;
        proxy_set_header Remote-Email $email;
        error_page 401 =302 https://authelia.test.rovacsek.com/?rd=$target_url;
      '';
    in
    {
      imports = [
        self.nixosModules.authelia
        self.nixosModules.nginx
        self.nixosModules.prometheus
      ];

      # Mock secrets option definition matching what agenix provides (roughly)
      options.age = {
        secrets = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options.path = lib.mkOption { type = lib.types.path; };
              options.file = lib.mkOption { type = lib.types.path; };
              options.owner = lib.mkOption {
                type = lib.types.str;
                default = "root";
              };
              options.group = lib.mkOption {
                type = lib.types.str;
                default = "root";
              };
              options.mode = lib.mkOption {
                type = lib.types.str;
                default = "0400";
              };
              options.name = lib.mkOption {
                type = lib.types.str;
                default = "secret";
              };
              options.symlink = lib.mkOption {
                type = lib.types.bool;
                default = true;
              };
            }
          );
          default = { };
        };
        identityPaths = lib.mkOption {
          type = lib.types.listOf lib.types.str; # identityPaths are usually strings or paths
          default = [ ];
        };
      };

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
        networking.hostName = "test-machine";
        networking.firewall.enable = false;

        # Add a domain to /etc/hosts so we can resolve it
        networking.hosts."127.0.0.1" = [
          "authelia.test.rovacsek.com"
          "prometheus-bypass.test.rovacsek.com"
          "prometheus-protected.test.rovacsek.com"
        ];

        # Configure nginx to be test mode (authelia module uses this to switch to test config)
        services.nginx.test.enable = true;
        services.nginx.domains = [ "rovacsek.com" ];

        # Fix for "access_control: 'default_policy' option 'deny' is invalid: when no rules are specified"
        services.authelia.instances.test.settings.access_control.rules = [
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

        # Generate VirtualHost for Authelia
        services.nginx.virtualHosts =
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
              locations."/".extraConfig = "include ${autheliaAuthRequest};";
            };
          })
          // (self.lib.nginx.generate-vhosts {
            inherit config;
            subdomain = "prometheus-protected";
            overrides = {
              locations."/".proxyPass = "http://127.0.0.1:9092";
              enableAuthelia = false;
              extraConfig = "include ${autheliaLocation};";
              locations."/".extraConfig = "include ${autheliaAuthRequest};";
            };
          });

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
