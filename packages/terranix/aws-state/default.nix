{ self, ... }:
let
  inherit (self.common.tofu.globals) aws;
  inherit (aws)
    buckets
    dynamo
    region
    tags
    ;
  inherit (aws.iam) state-statements;
in
{
  variable = {
    AWS_ACCESS_KEY = {
      type = "string";
      description = "AWS Access key";
      nullable = false;
      sensitive = true;
    };
    AWS_SECRET_KEY = {
      type = "string";
      description = "AWS Secret key";
      nullable = false;
      sensitive = true;
    };
  };

  terraform = {
    # TODO: ADD BACKEND HERE ONCE BOOTSTRAP'd
    required_providers = {
      aws = {
        source = "hashicorp/aws";
        version = "~> 5.0";
      };
    };
  };

  provider.aws = {
    inherit region;
    default_tags = {
      inherit tags;
    };
    access_key = "\${var.AWS_ACCESS_KEY}";
    secret_key = "\${var.AWS_SECRET_KEY}";
  };

  resource = {
    aws_iam_policy = {
      tf-state-modifier = {
        name = "tf-state-modifier";
        description = "A policy to enable state reading and writing";
        policy = "${builtins.toJSON {
          Version = "2012-10-17";
          Statement = state-statements;
        }}";
      };
    };

    aws_iam_user = {
      deployer = {
        name = "deployer";
        path = "/system/";
      };
    };

    aws_dynamodb_table.${dynamo.state.name} = {
      inherit (dynamo.state) name;
      billing_mode = "PAY_PER_REQUEST";
      hash_key = "UserId";

      attribute = [
        {
          name = "LockID";
          type = "S";
        }
        {
          name = "LockID";
          type = "HASH";
        }
      ];
    };

    aws_s3_bucket = {
      ${buckets.state.name} = {
        bucket = buckets.state.name;
        noncurrent_version_expiration.days = 90;
        noncurrent_version_transition = {
          days = 1;
          storage_class = "INTELLIGENT_TIERING";
        };

        inherit tags;
      };

      ${buckets.log.name} = {
        bucket = buckets.log.name;
        noncurrent_version_expiration.days = 90;
        noncurrent_version_transition = {
          days = 1;
          storage_class = "INTELLIGENT_TIERING";
        };

        inherit tags;
      };
    };

    aws_s3_bucket_server_side_encryption_configuration.${buckets.state.name} = {
      bucket = "\${resource.aws_s3_bucket.${buckets.state.name}.id}";
      rule.apply_server_side_encryption_by_default.sse_algorithm = "AES256";
    };

    aws_s3_bucket_public_access_block.${buckets.state.name} = {
      bucket = "\${resource.aws_s3_bucket.${buckets.state.name}.id}";
      block_public_acls = true;
      block_public_policy = true;
      ignore_public_acls = true;
      restrict_public_buckets = true;
    };

    aws_s3_bucket_versioning.${buckets.state.name} = {
      bucket = "\${resource.aws_s3_bucket.${buckets.state.name}.id}";
      versioning_configuration.status = "Enabled";
    };

    aws_s3_bucket_acl.${buckets.state.name} = {
      bucket = "\${resource.aws_s3_bucket.${buckets.state.name}.id}";
      acl = "private";
    };
  };
}
