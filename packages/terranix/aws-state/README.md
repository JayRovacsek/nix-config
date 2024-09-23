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

## Deployed Resources

| resource       | description                                  | name              | policy                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| -------------- | -------------------------------------------- | ----------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| aws_iam_policy | A policy to enable state reading and writing | tf-state-modifier | {"Statement":[{"Action":["dynamodb:DescribeTable","dynamodb:GetItem","dynamodb:PutItem","dynamodb:DeleteItem"],"Effect":"Allow","Resource":"arn:aws:dynamodb:ap-southeast-2:372627124797:table/terraform-state"},{"Action":["s3:ListBucket"],"Effect":"Allow","Resource":"arn:aws:s3:::676728e1b95-terraform"},{"Action":["s3:GetObject","s3:PutObject","s3:DeleteObject"],"Effect":"Allow","Resource":"arn:aws:s3:::676728e1b95-terraform/terraform/state/\*"}],"Version":"2012-10-17"} |

| resource     | name     | path     |
| ------------ | -------- | -------- |
| aws_iam_user | deployer | /system/ |
