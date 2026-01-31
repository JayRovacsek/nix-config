{ pkgs, self }:
pkgs.testers.runNixOSTest {
  name = "headscale-connectivity";

  nodes = {
    headscale =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        imports = [
          self.nixosModules.headscale
          ../options/modules/agenix/mock.nix
        ];

        _module.args.self = self;

        networking.hostName = "headscale";
        networking.firewall.allowedTCPPorts = [ 8080 ];

        # Mock secrets
        age.secrets = lib.mkForce {
          preauth-client1.path = pkgs.writeText "preauth-client1" "hs_preauth_client1_key";
          preauth-client2.path = pkgs.writeText "preauth-client2" "hs_preauth_client2_key";
        };

        services.headscale = {
          enable = true;
          address = "0.0.0.0";
          port = 8080;

          settings = {
            server_url = lib.mkForce "http://headscale:8080";
            dns.magic_dns = true;
            dns.base_domain = lib.mkForce "test.net";
            ip_prefixes = [ "100.64.0.0/10" ];

            database.path = "/var/lib/headscale/db.sqlite";
            derp.urls = lib.mkForce [ ];
            derp.auto_update_enable = lib.mkForce false;
          };

          use-declarative-users = true;

          users = lib.mkForce [
            {
              name = "client1@test.net";
              keys = [
                {
                  inherit (config.age.secrets.preauth-client1) path;
                  reusable = true;
                  ephemeral = true;
                }
              ];
            }
            {
              name = "client2@test.net";
              keys = [
                {
                  inherit (config.age.secrets.preauth-client2) path;
                  reusable = true;
                  ephemeral = true;
                }
              ];
            }
          ];

          # Temporarily use wildcard src to isolate user matching issues
          acl.acls = lib.mkForce [
            {
              action = "accept";
              src = [ "*" ];
              dst = [ "100.64.0.0/10:80" ];
            }
            {
              action = "accept";
              src = [ "*" ];
              proto = "icmp";
              dst = [ "100.64.0.0/10:*" ];
            }
          ];

        };

        environment.systemPackages = [ pkgs.sqlite ];
      };

    client1 =
      {
        pkgs,
        ...
      }:
      {
        networking.hostName = "client1";
        services.tailscale.enable = true;
        environment.systemPackages = [
          pkgs.curl
          pkgs.iputils
        ];
      };

    client2 =
      {
        pkgs,
        ...
      }:
      {
        networking.hostName = "client2";
        services.tailscale.enable = true;
        environment.systemPackages = [
          pkgs.curl
          pkgs.python3
          pkgs.iputils
        ];
        networking.firewall.allowedTCPPorts = [
          80
          9090
        ];
      };
  };

  testScript = ''
    start_all()

    headscale.wait_for_unit("headscale.service")

    # Wait for setup to verify users are created
    try:
        headscale.wait_for_unit("headscale-user-setup.service")
    except Exception as e:
        headscale.succeed("journalctl -u headscale-user-setup.service >&2")
        raise e

    # Authenticate client1
    client1.wait_for_unit("tailscaled.service")
    client1.succeed("tailscale up --login-server http://headscale:8080 --authkey hs_preauth_client1_key --hostname client1 --accept-routes")

    # Authenticate client2
    client2.wait_for_unit("tailscaled.service")
    client2.succeed("tailscale up --login-server http://headscale:8080 --authkey hs_preauth_client2_key --hostname client2 --accept-routes")

    # Give some time for coordination
    client1.wait_until_succeeds("tailscale ip -4")
    client2.wait_until_succeeds("tailscale ip -4")

    # Get Tailscale IPs
    ip1 = client1.succeed("tailscale ip -4").strip()
    ip2 = client2.succeed("tailscale ip -4").strip()

    # Verify connectivity (Ping)
    # Ping client2 from client1 using Tailscale IP
    client1.wait_until_succeeds(f"ping -c 1 {ip2}")

    # Test allowed port (80)
    # Start web server on client2
    client2.execute("python3 -m http.server 80 >&2 &")
    client2.wait_for_open_port(80)

    client1.wait_until_succeeds(f"curl --connect-timeout 5 http://{ip2}")

    # Test denied port (9090)
    # Start web server on client2 on port 9090
    client2.execute("python3 -m http.server 9090 >&2 &")
    client2.wait_for_open_port(9090)

    # This should fail because of ACLs
    client1.fail(f"curl --connect-timeout 2 http://{ip2}:9090")
  '';
}
