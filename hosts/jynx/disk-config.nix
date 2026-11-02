{ self, ... }:
{
  imports = [ self.inputs.disko.nixosModules.default ];

  disko = {
    enableConfig = true;

    devices = {
      disk = {
        main = {
          content = {
            partitions = {
              ESP = {
                content = {
                  format = "vfat";
                  mountOptions = [
                    "fmask=0077"
                    "dmask=0077"
                  ];
                  mountpoint = "/boot";
                  type = "filesystem";
                };
                size = "1G";
                type = "EF00";
              };
              root = {
                content = {
                  format = "ext4";
                  mountpoint = "/";
                  type = "filesystem";
                };
                size = "100%";
                uuid = "1863f057-304d-4c1a-baca-00f8caac630a";
              };
            };
            type = "gpt";
          };
          device = "/dev/disk/by-id/ata-WDC_WDS100T2B0B-00YS70_2013FP440804";
          type = "disk";
        };
      };
    };
  };
}
