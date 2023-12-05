<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.

## Providers

| Name                                                      | Version |
| --------------------------------------------------------- | ------- |
| <a name="provider_linode"></a> [linode](#provider_linode) | 2.0.0   |

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
| [linode_stackscripts.ditto-transform](https://registry.terraform.io/providers/linode/linode/latest/docs/data-sources/stackscripts)   | data source |

## Inputs

| Name                                                                  | Description      | Type     | Default | Required |
| --------------------------------------------------------------------- | ---------------- | -------- | ------- | :------: |
| <a name="input_LINODE_TOKEN"></a> [LINODE_TOKEN](#input_LINODE_TOKEN) | Linode API token | `string` | n/a     |   yes    |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
