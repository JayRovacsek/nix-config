{ pkgs, ... }:
let
  inherit (pkgs) coreutils writers;

  filename = ".conform.yaml";

  config = writers.writeYAML filename {
    policies = [{
      type = "commit";
      spec = {
        gpg.required = true;
        header = {
          length = 80;
          imperative = true;
          case = "lower";
          invalidLastCharacters = ".";
        };
        body.required = false;
        conventional = {
          types = [
            "build"
            "chore"
            "ci"
            "docs"
            "feat"
            "fix"
            "perf"
            "refactor"
            "release"
            "style"
            "test"
          ];
          scopes = [
            "apps"
            "checks"
            "common"
            "darwin"
            "flake"
            "home-manager-modules"
            "lib"
            "linux"
            "modules"
            "options"
            "overlays"
            "secrets"
            "shells"
            "static"
            "tooling"
            "users"
          ];
        };
      };
    }];
  };

  program = builtins.toString (pkgs.writers.writeBash "copy-config" ''
    ${coreutils}/bin/rm ./${filename}
    ${coreutils}/bin/ln -s ${config} ./${filename}
  '');

  type = "app";

in { generate-conform-config = { inherit program type; }; }
