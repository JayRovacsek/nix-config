{ pkgs, self, ... }:
let
  inherit (pkgs) coreutils system;

  type = "app";

  generate-cliff-config = let
    filename = "cliff.toml";

    config = self.packages.${system}.git-cliff-config;

    program = builtins.toString (pkgs.writers.writeBash "copy-config" ''
      ${coreutils}/bin/rm ./${filename}
      ${coreutils}/bin/ln -s ${config} ./${filename}
    '');
  in { inherit program type; };

  generate-conform-config = let
    filename = ".conform.yaml";

    config = self.packages.${system}.conform-config;

    program = builtins.toString (pkgs.writers.writeBash "copy-config" ''
      ${coreutils}/bin/rm ./${filename}
      ${coreutils}/bin/ln -s ${config} ./${filename}
    '');
  in { inherit program type; };

  generate-all-configs = {
    program = builtins.toString
      (pkgs.writers.writeBash "generate-all-configs" ''
        ${pkgs.nixVersions.stable}/bin/nix run ${self}#generate-cliff-config
        ${pkgs.nixVersions.stable}/bin/nix run ${self}#generate-conform-config
      '');

    type = "app";
  };

in {
  inherit generate-all-configs generate-cliff-config generate-conform-config;
}
