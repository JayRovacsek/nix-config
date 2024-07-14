{ self, ... }: {
  imports = [ self.inputs.disko.nixosModules.default ];

  fileSystems."/persistent" = {
    neededForBoot = true;
    depends = [ "/" ];
  };

  disko = {
    enableConfig = true;
    devices = {
      nodev."/" = {
        fsType = "tmpfs";
        mountOptions = [ "size=512M" ];
      };
      disk.system = {
        type = "disk";
        device = "/dev/mmcblk0";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              start = "1M";
              end = "30M";
              label = "FIRMWARE";
              type = "EF00";
              device = "/dev/disk/by-label/FIRMWARE";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/firmware";
                mountOptions = [ "nofail" "noauto" ];
              };
            };
            root = {
              size = "100%";
              label = "NIXOS_SD";
              device = "/dev/disk/by-label/NIXOS_SD";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/persistent";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };
    };
  };
}
