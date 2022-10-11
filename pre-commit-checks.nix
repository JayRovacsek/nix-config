{ self, pkgs, system }: {
  src = self;
  hooks = {
    nixfmt = {
      enable = true;
      excludes = [ ];
    };
    vulnix = {
      enable = true;
      name = "Vulnix Spicy CVE Check";
      entry = "${
          self.outputs.packages.${system}.vulnix-precommit
        }/bin/vulnix-precommit 7.5";

      files = "";
      language = "system";
    };
  };
}
