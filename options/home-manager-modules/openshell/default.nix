{
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption types;
  inherit (pkgs.stdenv.hostPlatform) system;

  # A document is either a file (Nix path or store path string) or an inline
  # attribute set. Files are read at build time, never at evaluation time.
  document =
    with types;
    oneOf [
      path
      str
      (attrsOf anything)
    ];

  gateway = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = ''
          Gateway name. Entries sharing a name are merged into one gateway,
          each name runs as its own service.
        '';
      };

      settings = mkOption {
        type = (pkgs.formats.toml { }).type;
        default = { };
        description = ''
          Gateway TOML configuration, rooted at the top level of the file
          (i.e. `openshell.gateway.*`, `openshell.drivers.*`).
          See https://docs.nvidia.com/openshell/latest/how-it-works/gateways/configuration
        '';
      };

      environment = mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = {
          DOCKER_HOST = "unix:///Users/me/.colima/default/docker.sock";
        };
        description = "Environment variables for the gateway process.";
      };
    };
  };
in
{
  options.services.openshell = {
    enable = mkEnableOption "OpenShell gateways, providers and policies";

    package = mkOption {
      type = types.package;
      default = self.packages.${system}.openshell;
      defaultText = lib.literalExpression "self.packages.\${system}.openshell";
      description = "Package providing openshell, openshell-gateway and openshell-prover.";
    };

    sharedPackage = mkOption {
      type = types.package;
      default = self.packages.${system}.openshell-shared;
      defaultText = lib.literalExpression "self.packages.\${system}.openshell-shared";
      description = "Package providing upstream share/providers and share/skills.";
    };

    gateways = mkOption {
      type = types.listOf gateway;
      default = [ { name = "openshell"; } ];
      example = lib.literalExpression ''
        [
          { name = "local"; }
          { name = "local"; settings.openshell.gateway.log_level = "debug"; }
        ]
      '';
      description = ''
        Gateways to run as user services (systemd on Linux, launchd on Darwin).

        Entries are grouped by `name` and merged with `foldl' recursiveUpdate`,
        so later entries in the list take precedence over earlier ones.

        Each gateway defaults to the docker compute driver, listens in
        plaintext on 127.0.0.1:17670 and allows unauthenticated local users.
        Gateways with distinct names must use distinct `bind_address` values.
      '';
    };

    providers = mkOption {
      type = types.listOf document;
      default = [ ];
      example = lib.literalExpression ''
        [
          "''${pkgs.openshell-shared}/share/providers/github.yaml"
          {
            id = "github";
            binaries = [
              "''${pkgs.git}/bin/git"
              "''${pkgs.gh}/bin/gh"
            ];
          }
        ]
      '';
      description = ''
        Provider profiles imported into every gateway as global profiles.

        Profiles are grouped by `id` and deep merged, so later entries in the
        list take precedence over earlier ones (lists, such as `binaries`, are
        replaced rather than appended). Global profiles not declared here are
        deleted from the gateway.
      '';
    };

    policies = mkOption {
      type = types.listOf document;
      default = [ ];
      description = ''
        Sandbox policy documents, deep merged into a single policy where later
        entries in the list take precedence over earlier ones (lists are
        replaced rather than appended). The result is exported as
        `OPENSHELL_SANDBOX_POLICY` for new sandboxes.
        See https://docs.nvidia.com/openshell/latest/how-it-works/policies/schema
      '';
    };

    globalPolicy = mkOption {
      type = types.nullOr (types.attrsOf types.anything);
      default = null;
      description = ''
        Gateway-global policy applied to every gateway. When null, any global
        policy present on the gateway is deleted.
      '';
    };

    boundaryPolicy = mkOption {
      type = types.nullOr document;
      default = null;
      description = ''
        Boundary policy. When set, the merged `policies` and `globalPolicy`
        are checked against it with `openshell-prover` at build time and the
        build fails if either exceeds the boundary.
      '';
    };

    opencode.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Add the upstream OpenShell skills to OpenCode when it is enabled.";
    };
  };
}
