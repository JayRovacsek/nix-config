{ self, pkgs, system }: {
  src = self;
  hooks = {
    nixfmt = {
      enable = true;
      excludes = [ ];
    };
    vulnix = {
      # Temporary while resolving upstream package issues
      enable = false;
      name = "Vulnix Spicy CVE Check";
        # Temporarily pinned to 40c6b517446510dfb238aed6b3e3f0eb81ee052c while making changes upstream:
        # entry = "${
        #   self.inputs.vulnix-pre-commit.packages.${system}.vulnix-precommit
        # }/bin/vulnix-pre-commit 7.5";
      entry = "${
          self.inputs.vulnix-pre-commit.packages.${system}.vulnix-precommit
        }/bin/vulnix-pre-commit 7.5";

      files = "";
      language = "system";
    };
  };
}
