{ self }:
let
  inherit (self.lib) merge;
  inherit (self.inputs) nixos-generators;

  # SD Installer Images / Configs
  aarch64 = import ./aarch64.nix { inherit self; };
  rpi1 = import ./rpi1.nix { inherit self; };
  rpi2 = import ./rpi2.nix { inherit self; };

  # Cloud Base Images
  amazon-cfg = import ./amazon.nix { inherit self; };
  linode-cfg = import ./linode.nix { inherit self; };
  oracle-cfg = import ./oracle.nix { inherit self; };

  amazon = let inherit (amazon-cfg._module.args) modules;
  in nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    modules = modules ++ [{ amazonImage.sizeMB = 16 * 1024; }];
    format = "amazon";
  };

  linode = let inherit (linode-cfg._module.args) modules;
  in nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    inherit modules;
    format = "linode";
  };

  oracle = let inherit (oracle-cfg._module.args) modules;
  in nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    inherit modules;
    format = "qcow";
  };

  cfgs = {
    configurations = {
      amazon = amazon-cfg;
      linode = linode-cfg;
      oracle = oracle-cfg;
      inherit aarch64 rpi1 rpi2;
    };
  };

  sd-images = builtins.map (image: {
    "${image.config.networking.hostName}-sdImage" =
      image.config.system.build.sdImage;
  }) [ aarch64 rpi1 rpi2 ];

  images = { inherit aarch64 amazon linode oracle; };

in merge ([ images cfgs ] ++ sd-images)
