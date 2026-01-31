{ pkgs, self }:
pkgs.testers.runNixOSTest {
  name = "anubis-proxy";
  nodes.machine =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ self.nixosModules.anubis ];

      _module.args.self = self;

      services.anubis.instances.default = {
        enable = true;
        settings.TARGET = lib.mkForce "http://127.0.0.1:9000";
      };

      systemd.services.mock-target = {
        description = "Mock Target Service";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.python3}/bin/python3 -m http.server 9000";
        };
      };

      networking.firewall.allowedTCPPorts = [
        4444
        9000
      ];
    };

  testScript = ''
    machine.wait_for_unit("mock-target.service")
    machine.wait_for_open_port(9000)

    machine.wait_for_unit("anubis-default.service")
    machine.wait_for_open_port(4444)

    # curl the anubis port, it should proxy to the mock target (python http server)
    machine.succeed("curl -v -H 'X-Real-Ip: 127.0.0.1' http://127.0.0.1:4444 | grep 'Directory listing'")
  '';
}
