{ self, pkgs, ... }:
let
  inherit (pkgs) lib openssh;

  inherit (lib) concatMapStringsSep;

  hosts = (builtins.attrNames self.nixosConfigurations)
    ++ (builtins.attrNames self.darwinConfigurations);

  program = builtins.toString
    (pkgs.writers.writeBash "generate-host-agenix-keys"
      (concatMapStringsSep "\n" (x: ''
        ${openssh}/bin/ssh-keygen -t ed25519 -C "" -f id-ed25519-${x}-primary -P ""
        ${openssh}/bin/ssh-keygen -t ed25519 -C "" -f id-ed25519-${x}-secondary -P ""
      '') hosts));

  type = "app";

in { generate-host-agenix-keys = { inherit program type; }; }
