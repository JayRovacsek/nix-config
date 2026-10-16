{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin system;
  inherit (self.packages.${system}) openshell-shared;
in
{
  imports = [ ../../options/home-manager-modules/openshell ];

  services.openshell = {
    enable = true;

    gateways = [
      {
        name = "openshell";
        # Colima does not expose /var/run/docker.sock on Darwin.
        environment = lib.optionalAttrs isDarwin {
          DOCKER_HOST = "unix://${config.home.homeDirectory}/.colima/default/docker.sock";
        };
        # Colima containers cannot reach host loopback; Lima exposes the host
        # (including its loopback listeners) at host.lima.internal.
        settings = lib.optionalAttrs isDarwin {
          openshell.drivers.docker.grpc_endpoint = "http://192.168.5.2:17670";
        };
      }
    ];

    providers = [
      "${openshell-shared}/share/providers/github.yaml"
      {
        id = "github";
        # Paths inside the sandbox image, not the host.
        binaries = [
          "/usr/bin/git"
          "/usr/bin/gh"
        ];
      }
    ];

    # Minimal sandbox policy: no network access beyond attached providers.
    policies = [ { version = 1; } ];
  };
}
