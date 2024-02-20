{ self, pkgs }:
let inherit (pkgs) system;
in {
  pre-commit = self.inputs.pre-commit-hooks.lib.${system}.run {
    src = self;
    hooks = {
      # Builtin hooks
      actionlint.enable = true;
      conform.enable = true;
      deadnix.enable = true;
      nixfmt.enable = true;
      prettier.enable = true;
      statix.enable = true;
      typos.enable = true;

      # Custom hooks
      git-cliff = {
        enable = true;
        name = "Git Cliff";
        entry = "${pkgs.git-cliff}/bin/git-cliff --output CHANGELOG.md";
        language = "system";
        pass_filenames = false;
      };

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
      prettier = {
        ignore-path = [ self.packages.${system}.prettierignore ];
        write = true;
      };
      typos.locale = "en-au";
    };
  };
}
