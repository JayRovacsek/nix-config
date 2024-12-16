{ self }:
let
  inherit (self.lib) merge;
  inherit (self.inputs) nixos-generators;

  modules = [
    self.inputs.raspberry-pi-nix.nixosModules.sd-image
    {
      # As we are only ever building this via binfmt allocations
      # disable compression as the performance of achieving compression is
      # not worth the few GB of disk savings at best
      sdImage.compressImage = false;
    }
  ];

  rpi4 = import ./rpi4.nix { inherit self; };
  rpi5 = import ./rpi5.nix { inherit self; };

  # SD Installer Images / Configs
  aarch64 = import ./aarch64.nix { inherit self; };
  rpi4-sd-image = rpi4.extendModules {
    inherit modules;
  };

  rpi5-sd-image = rpi5.extendModules {
    inherit modules;
  };

  # Cloud Base Images
  amazon-cfg = import ./amazon.nix { inherit self; };
  linode-cfg = import ./linode.nix { inherit self; };
  oracle-cfg = import ./oracle.nix { inherit self; };

  amazon = nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    modules = with self.nixosModules; [
      ../../hosts/ditto
      amazon-image
    ];
    specialArgs = {
      inherit self;
    };
    format = "amazon";
  };

  linode = nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    modules = with self.nixosModules; [
      ../../hosts/ditto
      linode-image
    ];
    specialArgs = {
      inherit self;
    };
    format = "linode";
  };

  oracle-aarch64 = nixos-generators.nixosGenerate {
    system = "aarch64-linux";
    modules = with self.nixosModules; [
      ../../hosts/ditto
      oracle-image
    ];
    specialArgs = {
      inherit self;
    };
    format = "qcow";
  };

  oracle-x86_64 = nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    modules = with self.nixosModules; [
      ../../hosts/ditto
      oracle-image
    ];
    specialArgs = {
      inherit self;
    };
    format = "qcow";
  };

  cfgs = {
    configurations = {
      amazon = amazon-cfg;
      linode = linode-cfg;
      oracle = oracle-cfg;
      inherit
        aarch64
        rpi4
        rpi5
        ;
    };
  };

  sd-images =
    builtins.map
      (image: {
        "${image.config.networking.hostName}-sdImage" =
          image.config.system.build.sdImage;
      })
      [
        aarch64
        rpi4-sd-image
        rpi5-sd-image
      ];

  images = {
    inherit
      aarch64
      amazon
      linode
      oracle-aarch64
      oracle-x86_64
      ;
  };

in
merge (
  [
    images
    cfgs
  ]
  ++ sd-images
)
