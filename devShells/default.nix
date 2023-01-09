{ self, system }:
let
  name = "dev-shell";

  pkgs = self.inputs.stable.legacyPackages.${system};

  shell-base = let packages = with pkgs; [ nixfmt statix vulnix nil ];
  in { inherit name packages; };

  shell = (let packages = with pkgs; [ nixfmt statix vulnix nil ];
  in if builtins.elem system self.common.pre-commit-unsupported then
    { }
  else {
    # Self reference to make the default shell hook that which generates
    # a suitable pre-commit hook installation
    inherit (self.checks.${system}.pre-commit) shellHook;
  }) // shell-base;
in {
  "${name}" = pkgs.mkShell shell;
  default = self.outputs.devShells.${system}.${name};
}
