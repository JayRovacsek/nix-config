_:
let
  region = "ap-southeast";
  name = "linode-openvpn";
in
{
  variable.LINODE_TOKEN = {
    type = "string";
    description = "Linode API token";
    nullable = false;
    sensitive = true;
  };

  terraform = {
    cloud = {
      hostname = "app.terraform.io";
      organization = "TSvY5rCj9RAYyz4z2W7JZ5VwY2ec9EDg";
      workspaces = {
        inherit name;
      };
    };
    required_providers.linode.source = "linode/linode";
  };

  provider.linode.token = "\${ var.LINODE_TOKEN }";

  data.linode_images.nixos-base-image = {
    filter = {
      name = "label";
      values = [ "nixos-base" ];
    };
  };

  resource = {
    linode_instance.diglett = {
      inherit region;

      label = "diglett";
      group = "nixos";
      tags = [ "nixos" ];
      type = "g6-nanode-1";
    };

    linode_instance_disk.boot = {
      label = "boot";
      linode_id = "\${linode_instance.diglett.id}";
      size = 15000;
      image = "\${data.linode_images.nixos-base-image.images.0.id}";
    };

    linode_instance_disk.swap = {
      label = "swap";
      linode_id = "\${linode_instance.diglett.id}";
      size = 512;
      filesystem = "swap";
    };

    linode_instance_config.diglett-config = {
      linode_id = "\${linode_instance.diglett.id}";
      label = "boot_config";
      booted = true;
      kernel = "linode/grub2";

      helpers = {
        devtmpfs_automount = false;
        distro = false;
        modules_dep = false;
        network = false;
        updatedb_disabled = false;
      };

      root_device = "/dev/sda";

      devices = {
        sda.disk_id = "\${linode_instance_disk.boot.id}";
        sdb.disk_id = "\${linode_instance_disk.swap.id}";
      };

      interface = [ { purpose = "public"; } ];
    };
  };
}
