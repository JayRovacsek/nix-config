{ pkgs, self }:
pkgs.testers.runNixOSTest {
  name = "headscale-declarative";

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.headscale
        ../options/modules/agenix/mock.nix
      ];

      config = {
        _module.args.self = self;

        # Mock secrets for headscale
        age.secrets = {
          preauth-work.path = pkgs.writeText "preauth-work" "hs_preauth_work_key_12345";
          preauth-reverse-proxy.path = pkgs.writeText "preauth-reverse-proxy" "hs_preauth_reverse_proxy_key_12345";
          preauth-nextcloud.path = pkgs.writeText "preauth-nextcloud" "hs_preauth_nextcloud_key_12345";
          preauth-log.path = pkgs.writeText "preauth-log" "hs_preauth_log_key_12345";
          preauth-general.path = pkgs.writeText "preauth-general" "hs_preauth_general_key_12345";
          preauth-game.path = pkgs.writeText "preauth-game" "hs_preauth_game_key_12345";
          preauth-download.path = pkgs.writeText "preauth-download" "hs_preauth_download_key_12345";
          preauth-dns.path = pkgs.writeText "preauth-dns" "hs_preauth_dns_key_12345";
          preauth-auth.path = pkgs.writeText "preauth-auth" "hs_preauth_auth_key_12345";
          preauth-admin.path = pkgs.writeText "preauth-admin" "hs_preauth_admin_key_12345";
        };

        # Basic networking
        networking = {
          hostName = "headscale-test";
          firewall.enable = false;
        };

        # Override database path to be in /tmp or predictable for test
        services.headscale.settings.database.path = "/var/lib/headscale/db.sqlite";

        # Disable DERP auto-update for offline test environment
        services.headscale.settings.derp = {
          auto_update_enable = pkgs.lib.mkForce false;
          urls = pkgs.lib.mkForce [ ];
        };

        environment.systemPackages = [ pkgs.sqlite ];
      };
    };

  testScript = ''
    machine.wait_for_unit("headscale.service")

    try:
        machine.wait_for_unit("headscale-user-setup.service")
    except Exception as e:
        machine.succeed("journalctl -u headscale-user-setup.service >&2")
        raise e

    # Check if users exist in DB

    # We use sqlite3 to query the DB

    # Check for user 'admin'
    machine.succeed("sqlite3 /var/lib/headscale/db.sqlite \"SELECT name FROM users WHERE name='admin';\" | grep admin")

    # Check for key for 'admin'
    # The key content should be what we wrote in the mock secret
    machine.succeed("sqlite3 /var/lib/headscale/db.sqlite \"SELECT key FROM pre_auth_keys WHERE key LIKE 'hs_preauth_admin_key_%';\" | grep hs_preauth_admin_key_12345")

    # Check ACL file generation
    machine.succeed("grep 'group:admin' /nix/store/*acl.json")
    machine.succeed("grep 'allow-to-self' /nix/store/*acl.json || grep 'group:work' /nix/store/*acl.json")

    # Check if headscale CLI sees the users (it should if DB is correct)
    machine.succeed("headscale users list | grep admin")
  '';
}
