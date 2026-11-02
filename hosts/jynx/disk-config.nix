{ self, ... }:
{
  imports = [ self.inputs.disko.nixosModules.default ];

  # Impermanence: "/" is a tmpfs (provided by modules/impermanence); the
  # single disk's data partition holds all persistent state at
  # /persistent. No LUKS — plain ext4, per host requirements.
  fileSystems = {
    "/".options = [ "size=12G" ];
    "/persistent".neededForBoot = true;
  };

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
                uuid = "c4f8a2e1-7b3d-4f5a-9c6e-2d8f1a0b3c4d";
              };
              root = {
                content = {
                  format = "ext4";
                  mountpoint = "/persistent";
                  type = "filesystem";
                };
                size = "100%";
                uuid = "8f7e6d5c-4b3a-4219-8765-4321fedcba98";
              };
            };
            type = "gpt";
          };
          device = "/dev/disk/by-id/nvme-CT1000T500SSD5_234544DE0DA1";
          type = "disk";
        };
      };
    };
  };
}
