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

## Deployed Resources

| resource           | name                | provider | records | ttl | type | zone_id               |
| ------------------ | ------------------- | -------- | ------- | --- | ---- | --------------------- |
| aws_route53_record | noobhealthyfuns.com | aws      | ...     | 300 | A    | Z07293822L0ODVN4UL1I4 |

## records

|${resource.linode_instance.linode-csgo.ip_address}|
|resource       |group      |image                                          |label      |provider|region      |root_pass           |stackscript_data|stackscript_id|tags|type         |
|---------------|-----------|-----------------------------------------------|-----------|--------|------------|--------------------|----------------|--------------|----|-------------|
|linode_instance|linode-csgo|${data.linode_stackscript.linode-csgo.images.0}|linode-csgo|linode |ap-southeast|${var.ROOT_PASSWORD}|... |401700 |... |g6-standard-2|

## stackscript_data

| autoteambalance | buyanywhere | friendlyfire | gslt                     | maxrounds | motd               | rconpassword             | roundtime | servername         | svpassword |
| --------------- | ----------- | ------------ | ------------------------ | --------- | ------------------ | ------------------------ | --------- | ------------------ | ---------- |
| Disabled        | Disabled    | Enabled      | ${var.GAME_SERVER_TOKEN} | 15        | Noob Healthy Funs! | ${var.GAME_SERVER_TOKEN} | 5         | Noob Healthy Funs! |            |

## tags

|linode-csgo|
