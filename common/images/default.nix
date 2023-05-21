{ self }:
let
  inherit (self.lib) merge;
  inherit (self) nixosConfigurations;
  inherit (self.inputs) nixos-generators;
  inherit (nixosConfigurations) rpi1 rpi2;

  sd-configurtations = [ rpi1 rpi2 ];

  amazon-base-image = let
    inherit (self.nixosConfigurations) amazon;
    inherit (amazon._module.args) modules;
  in nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    modules = modules ++ [{ amazonImage.sizeMB = 16 * 1024; }];
    format = "amazon";
  };

  linode-base-image = let
    inherit (self.nixosConfigurations) linode;
    inherit (linode._module.args) modules;
  in nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    inherit modules;
    format = "linode";
  };

  oracle-base-image = let
    inherit (self.nixosConfigurations) oracle;
    inherit (oracle._module.args) modules;
  in nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    inherit modules;
    format = "qcow";
  };

  sd-images = builtins.map (image: {
    "${image.config.networking.hostName}" = image.config.system.build.sdImage;
  }) sd-configurtations;

  cloud-images = {
    inherit amazon-base-image linode-base-image oracle-base-image;
  };

  images = [ cloud-images ] ++ sd-images;

in merge images
