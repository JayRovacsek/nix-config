<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.

## Providers

| Name                                                      | Version |
| --------------------------------------------------------- | ------- |
| <a name="provider_linode"></a> [linode](#provider_linode) | 2.27.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                 | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [linode_instance.diglett](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance)                      | resource    |
| [linode_instance_config.diglett-config](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance_config) | resource    |
| [linode_instance_disk.boot](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance_disk)               | resource    |
| [linode_instance_disk.swap](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance_disk)               | resource    |
| [linode_images.nixos-base-image](https://registry.terraform.io/providers/linode/linode/latest/docs/data-sources/images)              | data source |

## Inputs

| Name                                                                  | Description      | Type     | Default | Required |
| --------------------------------------------------------------------- | ---------------- | -------- | ------- | :------: |
| <a name="input_LINODE_TOKEN"></a> [LINODE_TOKEN](#input_LINODE_TOKEN) | Linode API token | `string` | n/a     |   yes    |

## Outputs

No outputs.

<!-- END_TF_DOCS -->

## Deployed Resources

| resource             | image                                              | label | linode_id                     | size  |
| -------------------- | -------------------------------------------------- | ----- | ----------------------------- | ----- |
| linode_instance_disk | ${data.linode_images.nixos-base-image.images.0.id} | boot  | ${linode_instance.diglett.id} | 15000 |
| linode_instance_disk | undefined                                          | swap  | ${linode_instance.diglett.id} | 512   |

| resource               | booted | devices | helpers | interface | kernel       | label       | linode_id                     | root_device |
| ---------------------- | ------ | ------- | ------- | --------- | ------------ | ----------- | ----------------------------- | ----------- |
| linode_instance_config | true   | ...     | ...     | ...       | linode/grub2 | boot_config | ${linode_instance.diglett.id} | /dev/sda    |

| resource        | group | label   | region       | tags | type        |
| --------------- | ----- | ------- | ------------ | ---- | ----------- |
| linode_instance | nixos | diglett | ap-southeast | ...  | g6-nanode-1 |
