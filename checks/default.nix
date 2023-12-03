{ self, pkgs }:
let
  inherit (pkgs) system;
  checks = {
    pre-commit = self.inputs.pre-commit-hooks.lib.${system}.run {
      src = self;
      hooks = {
        # Builtin hooks
        deadnix.enable = true;
        nixfmt.enable = true;
        prettier.enable = true;
        statix.enable = true;
        typos.enable = true;

        # Custom hooks
        statix-write = {
          enable = true;
          name = "Statix Write";
          entry = "${pkgs.statix}/bin/statix fix";
          language = "system";
          pass_filenames = false;
        };

        trufflehog-verified = {
          enable = true;
          name = "Trufflehog Search";
          entry =
            "${pkgs.trufflehog}/bin/trufflehog git file://. --since-commit HEAD --only-verified --fail --no-update";
          language = "system";
          pass_filenames = false;
        };

        trufflehog-regex = {
          enable = true;
          name = "Trufflehog Regex Search";
          entry =
            "${pkgs.trufflehog}/bin/trufflehog git file://. --since-commit HEAD --config .trufflehog/config.yaml --fail --no-verification -x ./.trufflehog/path_exclusions  --no-update";
          language = "system";
          pass_filenames = false;
        };
      };

      # Settings for builtin hooks, see also: https://github.com/cachix/pre-commit-hooks.nix/blob/master/modules/hooks.nix
      settings = {
        deadnix.edit = true;
        nixfmt.width = 80;
        prettier.write = true;
      };
    };
  };
in checks
