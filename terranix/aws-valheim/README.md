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

| Name                                                                                                                                                              | Type     |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_cloudwatch_event_rule.start_rule](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/cloudwatch_event_rule)                         | resource |
| [aws_cloudwatch_event_rule.stop_rule](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/cloudwatch_event_rule)                          | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/iam_role)                                                  | resource |
| [aws_iam_role_policy_attachment.lambda_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.example_instance](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/instance)                                             | resource |
| [aws_lambda_function.start_function](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/lambda_function)                                 | resource |
| [aws_lambda_function.stop_function](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/lambda_function)                                  | resource |

## Inputs

| Name                                                                        | Description    | Type     | Default | Required |
| --------------------------------------------------------------------------- | -------------- | -------- | ------- | :------: |
| <a name="input_AWS_ACCESS_KEY"></a> [AWS_ACCESS_KEY](#input_AWS_ACCESS_KEY) | AWS Access key | `string` | n/a     |   yes    |
| <a name="input_AWS_SECRET_KEY"></a> [AWS_SECRET_KEY](#input_AWS_SECRET_KEY) | AWS Secret key | `string` | n/a     |   yes    |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
