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
                size = "500M";
                type = "EF00";
              };
              root = {
                content = {
                  format = "ext4";
                  mountpoint = "/";
                  type = "filesystem";
                };
                size = "100%";
              };
            };
            type = "gpt";
          };
          device = "/dev/nvme0n1";
          type = "disk";
        };
      };
    };
  };
}
