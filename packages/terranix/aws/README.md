<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                   | Version |
| ------------------------------------------------------ | ------- |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | 4.54.0  |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | 4.54.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                       | Type     |
| -------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_iam_policy.tf-state-modifier](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/iam_policy) | resource |
| [aws_iam_user.deployer](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/iam_user)              | resource |

## Inputs

| Name                                                                        | Description    | Type     | Default | Required |
| --------------------------------------------------------------------------- | -------------- | -------- | ------- | :------: |
| <a name="input_AWS_ACCESS_KEY"></a> [AWS_ACCESS_KEY](#input_AWS_ACCESS_KEY) | AWS Access key | `string` | n/a     |   yes    |
| <a name="input_AWS_SECRET_KEY"></a> [AWS_SECRET_KEY](#input_AWS_SECRET_KEY) | AWS Secret key | `string` | n/a     |   yes    |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
