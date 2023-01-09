{ self }:
let
  pkgs = self.inputs.stable.legacyPackages.${system};
  pkg = pkgs.nixfmt;
in pkg
