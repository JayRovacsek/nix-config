{ self }:
let
  inherit (self.lib) merge;
  inherit (self) nixosConfigurations;
  inherit (self.inputs) nixos-generators;
  inherit (self.inputs.nixpkgs.lib) optional;
  inherit (self.inputs.nixpkgs.lib.attrsets) filterAttrs mapAttrsToList;
  inherit (nixosConfigurations) rpi1 rpi2;

  sd-configurtations = [ rpi1 rpi2 ];
  # TODO: the below addition of amazon is causing issues with 
  # generating linode images meaning we've borked the cloud-based-images
  # definition below.
  # Need to resolve the issue, move a majority of the code to lib.
  cloud-formats = [ "amazon" "linode" "qcow" ];

  cloud-base-images = builtins.foldl'
    (accumulator: set: (builtins.listToAttrs set) // accumulator) { }
    (mapAttrsToList (name: value:
      builtins.foldl' (accumulator: format:
        [{
          name = "${format}-base-image";
          value = let
            # Hack required due to this issue: https://github.com/nix-community/nixos-generators/issues/150
            inherit (value._module.args) modules;
            extraModules = optional (format == "amazon")
              (_: { amazonImage.sizeMB = 16 * 1024; });
          in nixos-generators.nixosGenerate {
            inherit format;
            inherit (value.pkgs.stdenv) system;
            modules = modules ++ extraModules;
          };
        }] ++ accumulator) [ ] cloud-formats

    ) (filterAttrs (name: _: builtins.elem name cloud-formats)
      nixosConfigurations));

  # Create a list of identifier to sdImage build derivations.
  sd-images = builtins.map (image: {
    "${image.config.networking.hostName}" = image.config.system.build.sdImage;
  }) sd-configurtations;

in merge ([ cloud-base-images ] ++ sd-images)
