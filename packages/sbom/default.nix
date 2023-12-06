{ self, pkgs }:
let
  inherit (pkgs) coreutils lib nix stdenvNoCC system;
  inherit (lib) mapAttrs';
  inherit (self.common.systems) linux;
  inherit (self.inputs.sbomnix.packages.${system}) sbomnix;

  linux-sboms = mapAttrs' (name: value: {
    name = "sbom-${name}";
    value = stdenvNoCC.mkDerivation {
      name = "sbom-${name}";
      inherit (value.config.system.nixos) version;
      meta.description = "SBOM artefacts generated for ${name}";

      phases = [ "buildPhase" ];

      buildInputs = [ nix sbomnix ];

      buildPhase = ''
        ${coreutils}/bin/mkdir -p $out/share

        ${sbomnix}/bin/sbomnix ${value.config.system.build.toplevel.drvPath}

        ${coreutils}/bin/cp sbom.cdx.json sbom.spdx.json sbom.csv $out/share
      '';
    };
  }) linux;

in linux-sboms
