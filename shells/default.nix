{ self, pkgs }:
let inherit (pkgs) system;
in {
  default = pkgs.mkShell {
    name = "dev-shell";
    packages = with pkgs; [
      deadnix
      nil
      nixfmt
      nixVersions.stable
      nodePackages.prettier
      statix
    ];
    inherit (self.checks.${system}.pre-commit) shellHook;
  };
}
