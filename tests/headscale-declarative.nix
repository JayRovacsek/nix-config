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

        # Serve plain HTTP (no ACME/TLS) and keep the DERP map offline. The
        # module's embedded DERP server (region 999) is added after GetDERPMap,
        # so it alone satisfies headscale 0.29's non-empty DERPMap requirement.
        # Empty urls avoids the upstream fetch that fails in the VM (no DNS).
        services.headscale.settings = {
          server_url = pkgs.lib.mkForce "http://127.0.0.1:8080";
          derp = pkgs.lib.mkForce {
            urls = [ ];
            auto_update_enabled = false;
          };
        };

        environment.systemPackages = [ pkgs.sqlite ];
      };
    };

  testScript = ''
    machine.wait_for_unit("headscale.service")

    try:
        machine.wait_for_unit("headscale-preauth-setup.service")
    except Exception as e:
        machine.succeed("journalctl -u headscale-preauth-setup.service >&2")
        raise e

    # All 10 declarative keys should be inserted
    machine.succeed("sqlite3 /var/lib/headscale/db.sqlite \"SELECT COUNT(*) FROM pre_auth_keys;\" | grep -x 10")

    # Keys are tagged and have no owning user (headscale 0.28+ model)
    machine.succeed("sqlite3 /var/lib/headscale/db.sqlite \"SELECT tags FROM pre_auth_keys WHERE key='hs_preauth_admin_key_12345';\" | grep tag:admin")
    machine.succeed("sqlite3 /var/lib/headscale/db.sqlite \"SELECT COUNT(*) FROM pre_auth_keys WHERE user_id IS NOT NULL;\" | grep -x 0")

    # No users are created anymore
    machine.succeed("sqlite3 /var/lib/headscale/db.sqlite \"SELECT COUNT(*) FROM users;\" | grep -x 0")

    # The CLI (via the unix socket) sees the keys too
    machine.succeed("headscale preauthkeys list | grep hs_preauth_admin_key_12345")

    # Check ACL file generation (policy v2: tagOwners + acls referencing tags,
    # no groups). Every tag used in the acls must be declared in tagOwners.
    machine.succeed("grep 'tagOwners' /nix/store/*acl.json")
    machine.succeed("grep 'tag:admin' /nix/store/*acl.json")
    machine.succeed("grep 'tag:work' /nix/store/*acl.json")
    machine.succeed("! grep -q 'group:' /nix/store/*acl.json")
  '';
}
