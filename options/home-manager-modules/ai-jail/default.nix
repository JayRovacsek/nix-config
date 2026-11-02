# Per-user ai-jail configuration: installs the ai-jail binary in the
# user's home profile and generates the tier wrapper scripts modelled on
# docs/openshell-profiles.md. Every tier launches
# `ai-jail <tier flags> opencode --standalone` — `--standalone` is
# required by opencode 2.x inside an ai-jail (upstream README, issues
# #137/#176) — passing any extra arguments through to opencode:
#
#   ai-locked  — default containment (private tmp home, project dir
#                read-write, opencode state mounted), no network except
#                the host inference port forwarded onto the sandbox
#                loopback.
#   ai-limited — same containment plus filtered egress to `allowHosts`
#                (hostnames match their subdomains; IP literals
#                accepted) and `allowPrivateHosts`, plus the forwarded
#                inference port.
#   ai-open    — unrestricted network (--network); local access stays
#                limited to the project dir and the private tmp home
#                (host loopback is directly reachable, so no forward).
#
# Upstream: https://github.com/akitaonrails/ai-jail (flake-pinned).
{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  cfg = config.programs.ai-jail;

  # A tier wrapper: the ai-jail binary with the tier's flags baked in.
  mkWrapper =
    { name, args }:
    pkgs.writeShellScriptBin name ''
      exec ${cfg.package}/bin/ai-jail ${lib.escapeShellArgs args} \
        opencode --standalone "$@"
    '';

  # `--allow-host <host>` pairs for every allow-listed host.
  allowHostArgs =
    hosts:
    lib.concatMap (host: [
      "--allow-host"
      host
    ]) hosts;

  # `--allow-private-host <host>` pairs for private/CGNAT-resolving hosts.
  allowPrivateHostArgs =
    hosts:
    lib.concatMap (host: [
      "--allow-private-host"
      host
    ]) hosts;
in
{
  options.programs.ai-jail = {
    enable = lib.mkEnableOption "ai-jail and its per-tier AI session wrappers";

    package = lib.mkOption {
      type = lib.types.package;
      # doCheck off for the same reason as the NixOS module: upstream's
      # command_path_env test needs /usr/bin/bwrap, which NixOS builders
      # do not have (see options/modules/ai-jail/default.nix).
      # overrideAttrs (not override): the upstream package value is a
      # derivation-style value exposing overrideAttrs only.
      default = (self.inputs.ai-jail.packages.${pkgs.system}.default).overrideAttrs {
        doCheck = false;
      };
      defaultText = lib.literalExpression ''
        (self.inputs.ai-jail.packages.$\{pkgs.system}.default).overrideAttrs { doCheck = false; }
      '';
      description = "The ai-jail package used by the wrapper scripts.";
    };

    inferencePort = lib.mkOption {
      type = lib.types.port;
      default = 11435;
      description = ''
        Host loopback port of the inference endpoint
        (services.halogen-flash-server) forwarded into locked and limited
        jails. ai-jail never authorises host loopback in filtered mode, so
        `--forward-port` is the only way to reach it without `--network`.
      '';
    };

    profiles = {
      locked = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to provide the ai-locked wrapper.";
        };

        extraArgs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Extra ai-jail flags appended to the ai-locked wrapper.";
        };
      };

      limited = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to provide the ai-limited wrapper.";
        };

        extraArgs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Extra ai-jail flags appended to the ai-limited wrapper.";
        };

        allowHosts = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "cache.nixos.org"
            "ghcr.io"
            "github.com"
            "raw.githubusercontent.com"
          ];
          defaultText = lib.literalExpression ''
            [ "cache.nixos.org" "ghcr.io" "github.com" "raw.githubusercontent.com" ]
          '';
          description = ''
            Filtered-egress allow-list for the ai-limited tier, matching
            the GitHub family and Nix cache set of docs/openshell-profiles.md.
            Hostnames match their subdomains (`github.com` covers
            `api.github.com` and `codeload.github.com`); IP literals are
            accepted. Public addresses only — private-range addresses go
            in `allowPrivateHosts`.
          '';
        };

        allowPrivateHosts = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = ''
            Hosts additionally permitted to resolve to private/CGNAT
            addresses (`--allow-private-host`); loopback stays denied.
          '';
        };
      };

      open = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to provide the ai-open wrapper.";
        };

        extraArgs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Extra ai-jail flags appended to the ai-open wrapper.";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
    ]
    ++ lib.optional cfg.profiles.locked.enable (mkWrapper {
      name = "ai-locked";
      args = [
        "--no-network"
        "--forward-port"
        (toString cfg.inferencePort)
      ]
      ++ cfg.profiles.locked.extraArgs;
    })
    ++ lib.optional cfg.profiles.limited.enable (mkWrapper {
      name = "ai-limited";
      args =
        allowHostArgs cfg.profiles.limited.allowHosts
        ++ allowPrivateHostArgs cfg.profiles.limited.allowPrivateHosts
        ++ [
          "--forward-port"
          (toString cfg.inferencePort)
        ]
        ++ cfg.profiles.limited.extraArgs;
    })
    ++ lib.optional cfg.profiles.open.enable (mkWrapper {
      name = "ai-open";
      args = [ "--network" ] ++ cfg.profiles.open.extraArgs;
    });
  };
}
