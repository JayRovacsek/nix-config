{ self }:
let
  fn = { pkgs, ... }:
    let
      inherit (pkgs) system;
      inherit (self.packages.${system}) self-signed-certificate;

    in {
      generate-self-signed = domain:
        self-signed-certificate { inherit domain; };
    };
in fn
