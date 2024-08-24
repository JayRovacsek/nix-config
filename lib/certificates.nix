_:
let
  fn =
    { pkgs, ... }:
    let
      inherit (pkgs) callPackage;
    in
    {
      generate-self-signed =
        domain:
        callPackage ../packages/other/self-signed-certificate { inherit domain; };
    };
in
fn
