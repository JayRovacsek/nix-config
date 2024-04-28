{ self, ... }: {
  imports = [ self.inputs.disko.nixosModules.default ];

  age = {
    identityPaths = [ "/agenix/id-ed25519-zfs-primary" ];
    secrets.zfs-fde-key.file = ../../secrets/zfs/dragonite-fde-key.age;
  };

  disko.devices = {
    disk = {
      wwn-0x5000c500c892b513 = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x5000c500c892b513";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };
      };
      wwn-0x5000c500c7db3a72 = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x5000c500c7db3a72";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };
      };
      wwn-0x5000c500e84f2745 = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x5000c500e84f2745";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };
      };
    };

    zpool = {
      tank = {
        type = "zpool";
        mode = "raidz";
        rootFsOptions = {
          "com.sun:auto-snapshot" = "false";
          acltype = "posixacl";
          atime = "off";
          compression = "zstd";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          /* *
             This is hard-coded as a reference to config here causes infinite
             recursion. For now, the assumption of /run/agenix is relatively
             safe.
          */
          keylocation = "file:///run/agenix/zfs-fde-key";
          mountpoint = "none";
          relatime = "off";
          xattr = "sa";
        };

        datasets = builtins.foldl' (acc: dataset:
          acc // {
            ${dataset} = {
              mountpoint = "/srv/${dataset}";
              type = "zfs_fs";
            };
          }) { } [
            "containers"
            "databases"
            "downloads"
            "games"
            "isos"
            "logs"
            "movies"
            "music"
            "nextcloud"
            "osts"
            "storage"
            "tv"
          ];
      };
    };
  };
}
