{ writers, ... }:
# TODO: figure if I can ever remove the hardcoded site value on the 
# last line of the config
writers.writeYAML ".conform.yaml" {
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
          "hydra"
          "lib"
          "linux"
          "modules"
          "options"
          "overlays"
          "packages"
          "secrets"
          "shells"
          "static"
          "tooling"
          "users"
        ];
      };
    };
  }];
}
