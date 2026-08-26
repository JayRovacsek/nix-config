{
  self,
  ...
}:
let
  # This is only required in order to build the flashable image from
  # an x86 system across to the target fash.
  builderPkgs = self.common.package-sets.x86_64-linux-unstable;
in
{
  imports = [
    self.inputs.disko.nixosModules.default
    ./disko-make-disk-image.nix
  ];

  fileSystems."/" = {
    neededForBoot = true;
    autoResize = true;
  };

  disko = {
    enableConfig = true;

    imageBuilder = {
      enableBinfmt = true;
      pkgs = builderPkgs;
      kernelPackages = builderPkgs.linuxPackages;
    };

    devices.disk.rootfs = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN7100_2TB_25120M803177";
      imageSize = "8G";
      content = {
        type = "gpt";
        partitions.boot = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        partitions.root = {
          size = "100%";
          type = "B921B045-1DF0-41C3-AF44-4C6F280D3FAE"; # Linux root (ARM-64)
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            mountOptions = [ "noatime" ];
          };
        };
      };
    };
  };
}
