# Per-user ai-jail configuration: installs the ai-jail binary in the
# user's home profile and generates the tier wrapper scripts. Every tier
# launches `ai-jail <tier flags> opencode --standalone` — `--standalone` is
# required by opencode 2.x inside an ai-jail (upstream README, issues
# #137/#176) — passing any extra arguments through to opencode:
#
#   ai-locked       — default containment (private tmp home, project dir
#                     read-write, opencode state mounted), filtered egress
#                     restricted to `profiles.locked.allowHosts` (the
#                     halogen inference endpoint `127.0.0.1` by default)
#                     plus the forwarded inference port; an empty list
#                     falls back to pure `--no-network` isolation.
#   ai-locked-yolo  — same containment, plus `opencode --auto`: permissions
#                     that are not explicitly denied are auto-approved
#                     (the deny list still blocks; see
#                     home-manager-modules/opencode for the permission set).
#   ai-limited      — same containment plus filtered egress to `allowHosts`
#                     (hostnames match their subdomains; IP literals
#                     accepted) and `allowPrivateHosts`, plus the forwarded
#                     inference port, plus the read-only `gitPaths` mounts.
#   ai-limited-yolo — ai-limited with `opencode --auto`.
#   ai-open         — unrestricted network (--network); local access stays
#                     limited to the project dir and the private tmp home
#                     (host loopback is directly reachable, so no forward),
#                     plus the read-only `gitPaths` mounts.
#   ai-open-yolo    — ai-open with `opencode --auto`.
#
# The locked tier deliberately omits `gitPaths`: locked sessions get no
# git config, allowed_signers or signing key, so they cannot sign or
# authenticate as the user.
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
  # `opencodeArgs` are appended to the opencode invocation (e.g. [ "--auto" ]
  # for the yolo variants); `args` remain the ai-jail sandbox flags so a
  # yolo wrapper inherits the exact containment of its base tier.
  mkWrapper =
    {
      name,
      args,
      opencodeArgs ? [ ],
    }:
    pkgs.writeShellScriptBin name ''
      exec ${cfg.package}/bin/ai-jail ${lib.escapeShellArgs args} \
        opencode --standalone ${lib.escapeShellArgs opencodeArgs} "$@"
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

  # `--map <path>` pairs for every read-only mount.
  mapArgs =
    paths:
    lib.concatMap (path: [
      "--map"
      path
    ]) paths;

  # Per-tier ai-jail flags, shared by each tier's standard and yolo wrappers.
  tierArgs = {
    # With allowHosts set (the default), the locked jail runs in filtered
    # egress mode so the egress proxy authorises the halogen inference
    # endpoint; an empty list restores pure `--no-network` isolation where
    # `--forward-port` is the only route to the host.
    locked =
      (lib.optionals (cfg.profiles.locked.allowHosts == [ ]) [ "--no-network" ])
      ++ allowHostArgs cfg.profiles.locked.allowHosts
      ++ [
        "--forward-port"
        (toString cfg.inferencePort)
      ]
      ++ cfg.profiles.locked.extraArgs;

    limited =
      allowHostArgs cfg.profiles.limited.allowHosts
      ++ allowPrivateHostArgs cfg.profiles.limited.allowPrivateHosts
      ++ [
        "--forward-port"
        (toString cfg.inferencePort)
      ]
      ++ mapArgs cfg.gitPaths
      ++ cfg.profiles.limited.extraArgs;

    open = [ "--network" ] ++ mapArgs cfg.gitPaths ++ cfg.profiles.open.extraArgs;
  };

  # The wrappers a tier provides: always the standard one when enabled,
  # plus the yolo variant when the tier's `yolo` option is enabled.
  mkTierPackages =
    tier:
    let
      profile = cfg.profiles.${tier};
    in
    lib.optionals profile.enable (
      [
        (mkWrapper {
          name = "ai-${tier}";
          args = tierArgs.${tier};
        })
      ]
      ++ lib.optional profile.yolo (mkWrapper {
        name = "ai-${tier}-yolo";
        args = tierArgs.${tier};
        opencodeArgs = [ "--auto" ];
      })
    );
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
        jails. In filtered-egress mode the forwarded port is the only
        route to the endpoint without `--network`; the locked tier
        additionally authorises it through the egress proxy via
        `profiles.locked.allowHosts` (default `127.0.0.1`).
      '';
    };

    gitPaths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "${config.home.homeDirectory}/.config/git" ];
      defaultText = lib.literalExpression ''[ "$\{config.home.homeDirectory}/.config/git" ]'';
      description = ''
        Standard git config locations mounted read-only into the limited
        and open jails (and their yolo variants): git config,
        allowed_signers and the git signing key. The locked tier omits
        them so locked sessions cannot sign or authenticate as the user.
      '';
    };

    profiles = {
      locked = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to provide the ai-locked wrapper.";
        };

        yolo = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to provide the ai-locked-yolo wrapper: the same jail as
            ai-locked, launching opencode with `--auto` so permissions that
            are not explicitly denied are auto-approved. Has no effect when
            `profiles.locked.enable` is false.
          '';
        };

        extraArgs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Extra ai-jail flags appended to the ai-locked wrapper.";
        };

        allowHosts = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "127.0.0.1" ];
          defaultText = lib.literalExpression ''[ "127.0.0.1" ]'';
          description = ''
            Filtered-egress allow-list for the ai-locked tier: the halogen
            inference endpoint on the host loopback
            (services.halogen-flash-server, published to opencode as the
            `halogen-server` provider at http://127.0.0.1:11435/v1).
            Without it the jail has no route to the model and the harness
            cannot serve requests. Set to [ ] to fall back to pure
            `--no-network` isolation (forward-port only).
          '';
        };
      };

      limited = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to provide the ai-limited wrapper.";
        };

        yolo = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to provide the ai-limited-yolo wrapper: the same jail as
            ai-limited, launching opencode with `--auto` so permissions that
            are not explicitly denied are auto-approved. Has no effect when
            `profiles.limited.enable` is false.
          '';
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
            Filtered-egress allow-list for the ai-limited tier, covering
            the GitHub family and Nix cache hosts. Hostnames match their
            subdomains (`github.com` covers `api.github.com` and
            `codeload.github.com`); IP literals are accepted. Public
            addresses only — private-range addresses go in
            `allowPrivateHosts`.
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

        yolo = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to provide the ai-open-yolo wrapper: the same jail as
            ai-open, launching opencode with `--auto` so permissions that
            are not explicitly denied are auto-approved. Has no effect when
            `profiles.open.enable` is false.
          '';
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
    ++ mkTierPackages "locked"
    ++ mkTierPackages "limited"
    ++ mkTierPackages "open";
  };
}
