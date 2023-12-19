{ self, pkgs }:
let
  inherit (pkgs) system;
  name = "dev-shell";
  node-deps = with pkgs.nodePackages; [ prettier ];
  packages = (with pkgs; [ deadnix nixfmt statix ]) ++ node-deps;
in {
  "${name}" = pkgs.mkShell {
    inherit name packages;
    inherit (self.checks.${system}.pre-commit) shellHook;
  };
  default = self.outputs.devShells.${system}.${name};
}
