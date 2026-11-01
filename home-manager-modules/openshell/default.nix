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

        # One sandbox per policy tier (docs/openshell-profiles.md), each on
        # the module default image (nixpkgs/nix-flakes) with a generated
        # wrapper command of the same name.
        #
        # The nix-flakes image ships nix and bash but no `opencode` binary,
        # and the locked tier's offline policy cannot fetch one via nix, so
        # ai-locked runs /bin/bash — the agent shell declared by the
        # halogen-server provider. The disabled tiers keep the module
        # default `opencode` until a BYOC image provides it.
        sandboxes = {
          # Inference-only session. Active: the halogen-server provider
          # instance exists on this gateway.
          ai-locked = {
            command = [ "/bin/bash" ];
            tty = true;
            providers = [ "halogen-server" ];
            policy = ./profiles/locked.yaml;
          };

          # + GitHub and the Nix cache. Disabled until a `github` provider
          # instance exists: this host has no `gh` and no
          # GITHUB_TOKEN/GH_TOKEN for `--auto-providers` to discover.
          ai-limited = {
            enable = false;
            providers = [
              "halogen-server"
              "github"
            ];
            policy = ./profiles/limited.yaml;
          };

          # + the AI-provider profiles from openshell-shared. Disabled for
          # the same reason as ai-limited, plus missing credentials for the
          # openai/anthropic/openrouter/deepinfra/nvidia provider instances.
          ai-open = {
            enable = false;
            providers = [
              "halogen-server"
              "github"
              "openai"
              "anthropic"
              "openrouter"
              "deepinfra"
              "nvidia"
            ];
            policy = ./profiles/open.yaml;
          };
        };
      }
    ];

    # Provider catalog: the custom inference profile plus the upstream
    # profiles the tiers attach. The shared github profile ships without
    # `binaries`, so the inline override adds the sandbox-image paths.
    providers = [
      ./profiles/halogen-server.yaml
      "${openshell-shared}/share/providers/github.yaml"
      {
        id = "github";
        # Paths inside the sandbox image, not the host.
        binaries = [
          "/usr/bin/git"
          "/usr/bin/gh"
        ];
      }
      "${openshell-shared}/share/providers/openai.yaml"
      "${openshell-shared}/share/providers/anthropic.yaml"
      "${openshell-shared}/share/providers/openrouter.yaml"
      "${openshell-shared}/share/providers/deepinfra.yaml"
      "${openshell-shared}/share/providers/nvidia.yaml"
    ];

    # Default policy for ad-hoc `sandbox create` runs; the declared
    # sandboxes carry their tier policies via `sandboxes.*.policy`.
    policies = [ { version = 1; } ];
  };
}
