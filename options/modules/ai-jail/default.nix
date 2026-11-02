# System-wide availability of ai-jail, the AI-agent sandbox (bubblewrap +
# Landlock + seccomp). The package comes from the pinned ai-jail flake
# input; per-user session wrappers (ai-locked, ai-limited, ai-open) are
# declared in ../home-manager-modules/ai-jail.
#
# Upstream: https://github.com/akitaonrails/ai-jail — GPL-3.0-only Rust
# sandboxer by akitaonrails, vendored via flake input because nixpkgs does
# not package it yet.
{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  cfg = config.programs.ai-jail;
in
{
  options.programs.ai-jail = {
    enable = lib.mkEnableOption "the ai-jail AI-agent sandbox binary";

    package = lib.mkOption {
      type = lib.types.package;
      # doCheck is off: upstream's command_path_env test execs the
      # ai-jail binary with env_clear() (dropping BWRAP_BIN) and then
      # requires /usr/bin/bwrap — present on upstream's Ubuntu CI
      # runners, absent on NixOS builders, where the build sandbox has
      # no /usr/bin. The compile itself is verified against our tree.
      # overrideAttrs (not override): the upstream package value is a
      # derivation-style value exposing overrideAttrs only.
      default = (self.inputs.ai-jail.packages.${pkgs.system}.default).overrideAttrs {
        doCheck = false;
      };
      defaultText = lib.literalExpression ''
        (self.inputs.ai-jail.packages.$\{pkgs.system}.default).overrideAttrs { doCheck = false; }
      '';
      description = "The ai-jail package to make available on the system.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
