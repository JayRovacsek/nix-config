{ self, pkgs }:
let
  inherit (pkgs) lib system;

  name = "dev-shell";
  supported-system = !(builtins.elem system self.common.pre-commit-unsupported);

  nodePackages = with pkgs.nodePackages; [ prettier ];

  packages = with pkgs;
    lib.optionals supported-system
    ([ deadnix nixfmt statix nil ] ++ nodePackages);

  shellHook = lib.optionalString supported-system
    self.checks.${system}.pre-commit.shellHook;
in {
  "${name}" = pkgs.mkShell { inherit name packages shellHook; };
  default = self.outputs.devShells.${system}.${name};
}
