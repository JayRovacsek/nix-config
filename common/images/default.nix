{ self }:
let
  inherit (self) nixosConfigurations;
  inherit (self.inputs) nixos-generators;
  inherit (self.inputs.stable.lib) recursiveUpdate;
  inherit (self.inputs.stable.lib.attrsets) filterAttrs mapAttrsToList;
  inherit (nixosConfigurations) rpi1 rpi2;

  sd-configurtations = [ rpi1 rpi2 ];
  cloud-formats = [ "linode" "qcow" ];

  cloud-base-images = builtins.foldl'
    (accumulator: set: (builtins.listToAttrs set) // accumulator) { }
    (mapAttrsToList (name: value:
      builtins.foldl' (accumulator: format:
        [{
          name = "${format}-base-image";
          value = nixos-generators.nixosGenerate {
            inherit format;
            inherit (value.pkgs.stdenv) system;
            inherit (value._module.args) modules;
          };
        }] ++ accumulator) [ ] cloud-formats

    ) (filterAttrs (name: _: builtins.elem name cloud-formats)
      nixosConfigurations));

  # Create a list of identifer to sdImage build derivations.
  sd-images = builtins.map (image: {
    "${image.config.networking.hostName}" = image.config.system.build.sdImage;
  }) sd-configurtations;

  # Fold list of image name => derivation into a set rather than a list
in builtins.foldl' recursiveUpdate cloud-base-images sd-images
