{ pkgs, self }:
pkgs.testers.runNixOSTest {
  name = "anubis-integration";

  nodes = {
    backend =
      { pkgs, ... }:
      {
        networking.firewall.allowedTCPPorts = [ 3000 ];
        systemd.services.mock-hydra = {
          description = "Mock Hydra Service";
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${pkgs.python3}/bin/python3 -m http.server 3000 --directory ${pkgs.writeTextDir "index.html" "Hydra is running"}";
          };
        };
      };

    proxy =
      {
        lib,
        ...
      }:
      {
        imports = [ self.nixosModules.anubis ];

        _module.args.self = self;

        networking.firewall.allowedTCPPorts = [
          80
          4444
        ];

        # Configure Anubis
        # We override the TARGET to point to the backend node
        services.anubis.instances.default = {
          enable = true;
          settings = {
            # Use lib.mkForce to override the default which pulls from common.config
            TARGET = lib.mkForce "http://backend:3000";
            BIND = lib.mkForce ":4444";
          };
        };

        # Configure Nginx
        # Minimal configuration to mimic the Nidorina setup (Nginx -> Anubis)
        services.nginx = {
          enable = true;
          virtualHosts."hydra.test" = {
            locations."/" = {
              proxyPass = "http://127.0.0.1:4444";
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-Ip $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
              '';
            };
          };
        };
      };
  };

  testScript = ''
    start_all()

    backend.wait_for_unit("mock-hydra.service")
    backend.wait_for_open_port(3000)

    proxy.wait_for_unit("anubis-default.service")
    proxy.wait_for_unit("nginx.service")
    proxy.wait_for_open_port(4444)
    proxy.wait_for_open_port(80)

    # Test 1: Direct access to Anubis (simulating internal traffic or direct curl)
    # This verifies Anubis works when headers are provided correctly
    proxy.succeed("curl -v -f -H 'X-Real-Ip: 127.0.0.1' http://127.0.0.1:4444 | grep 'Hydra is running'")

    # Test 2: Access via Nginx
    # This verifies that Nginx is correctly adding the headers required by Anubis
    # We curl Nginx (localhost:80) with the Host header
    proxy.succeed("curl -v -f -H 'Host: hydra.test' http://127.0.0.1:80 | grep 'Hydra is running'")
  '';
}
