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
                  mountOptions = [ "umask=0077" ];
                  mountpoint = "/boot";
                  type = "filesystem";
                };
                size = "1G";
                type = "EF00";
                uuid = "e75ae1c6-3f62-4fc4-aa20-d1cf1fcd9c43";
              };
              root = {
                content = {
                  format = "ext4";
                  mountpoint = "/";
                  type = "filesystem";
                };
                size = "100%";
                uuid = "715c702d-7f78-4458-ac3b-a6310e652d4e";
              };
            };
            type = "gpt";
          };
          device = "/dev/nvme1n1";
          type = "disk";
        };
      };
    };
  };
}
