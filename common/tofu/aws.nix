{ self }:
let
  account-id = 372627124797;
  region = "ap-southeast-2";

  ami-bucket = "amis-${builtins.toString account-id}";
  ami-path = "ami";
  log-bucket = "logs-${builtins.toString account-id}";
  log-path = "terraform/logs";
  state-bucket = "terraform-state-${builtins.toString account-id}";
  state-path = "terraform/state";
  state-table = "terraform-state";

  ddb = [
    {
      Effect = "Allow";
      Action = [
        "dynamodb:DescribeTable"
        "dynamodb:GetItem"
        "dynamodb:PutItem"
        "dynamodb:DeleteItem"
      ];
      Resource = "arn:aws:dynamodb:${region}:${builtins.toString account-id}:table/${state-table}";
    }
  ];

  s3 = [
    {
      Effect = "Allow";
      Action = [ "s3:ListBucket" ];
      Resource = "arn:aws:s3:::${state-bucket}";
    }
    {
      Effect = "Allow";
      Action = [
        "s3:GetObject"
        "s3:PutObject"
        "s3:DeleteObject"
      ];
      Resource = "arn:aws:s3:::${state-bucket}/${state-path}/*";
    }
  ];

  state-statements = ddb ++ s3;
in
{
  buckets = {
    state = {
      name = state-bucket;
      path = state-path;
    };
    ami = {
      name = ami-bucket;
      path = ami-path;
    };
    log = {
      name = log-bucket;
      path = log-path;
    };
  };
  dynamo = {
    state = {
      name = state-table;
    };
  };
  iam = {
    inherit state-statements;
  };

  inherit region account-id;
  tags = {
    build = self.common.self.rev or self.common.self.dirtyRev or "orphaned";
  };
}
