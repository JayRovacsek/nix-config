<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                            | Version |
| --------------------------------------------------------------- | ------- |
| <a name="requirement_aws"></a> [aws](#requirement_aws)          | 4.54.0  |
| <a name="requirement_linode"></a> [linode](#requirement_linode) | 1.30.0  |

## Providers

| Name                                                      | Version |
| --------------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws)          | 4.54.0  |
| <a name="provider_linode"></a> [linode](#provider_linode) | 1.30.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                         | Type        |
| ---------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_route53_record.linode-csgo](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/route53_record) | resource    |
| [linode_instance.linode-csgo](https://registry.terraform.io/providers/linode/linode/1.30.0/docs/resources/instance)          | resource    |
| [linode_stackscript.linode-csgo](https://registry.terraform.io/providers/linode/linode/1.30.0/docs/data-sources/stackscript) | data source |

## Inputs

| Name                                                                                 | Description                         | Type     | Default | Required |
| ------------------------------------------------------------------------------------ | ----------------------------------- | -------- | ------- | :------: |
| <a name="input_AWS_ACCESS_KEY"></a> [AWS_ACCESS_KEY](#input_AWS_ACCESS_KEY)          | AWS Access key                      | `string` | n/a     |   yes    |
| <a name="input_AWS_SECRET_KEY"></a> [AWS_SECRET_KEY](#input_AWS_SECRET_KEY)          | AWS Secret key                      | `string` | n/a     |   yes    |
| <a name="input_GAME_SERVER_TOKEN"></a> [GAME_SERVER_TOKEN](#input_GAME_SERVER_TOKEN) | Instance GAME_SERVER_TOKEN Password | `string` | n/a     |   yes    |
| <a name="input_LINODE_TOKEN"></a> [LINODE_TOKEN](#input_LINODE_TOKEN)                | Linode API token                    | `string` | n/a     |   yes    |
| <a name="input_RCON_PASSWORD"></a> [RCON_PASSWORD](#input_RCON_PASSWORD)             | Instance RCON Password              | `string` | n/a     |   yes    |
| <a name="input_ROOT_PASSWORD"></a> [ROOT_PASSWORD](#input_ROOT_PASSWORD)             | Instance root password              | `string` | n/a     |   yes    |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
