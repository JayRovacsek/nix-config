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
                uuid = "47577528-ac5c-4c27-8da6-b9d8d7bfb91a";
              };
              root = {
                content = {
                  format = "ext4";
                  mountpoint = "/";
                  type = "filesystem";
                };
                size = "100%";
                uuid = "4c9cb6cd-2d5b-4345-a935-8113427648dc";
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
