{ self }:
let
  account-id = 372627124797;
  region = "ap-southeast-2";

  amiBucket = "amis-${builtins.toString account-id}";
  amiPath = "ami";
  logBucket = "logs-${builtins.toString account-id}";
  logPath = "terraform/logs";
  stateBucket = "terraform-state-${builtins.toString account-id}";
  statePath = "terraform/state";
  stateTable = "terraform-state";

  ddb = [
    {
      Effect = "Allow";
      Action = [
        "dynamodb:DescribeTable"
        "dynamodb:GetItem"
        "dynamodb:PutItem"
        "dynamodb:DeleteItem"
      ];
      Resource = "arn:aws:dynamodb:${region}:${builtins.toString account-id}:table/${stateTable}";
    }
  ];

  s3 = [
    {
      Effect = "Allow";
      Action = [ "s3:ListBucket" ];
      Resource = "arn:aws:s3:::${stateBucket}";
    }
    {
      Effect = "Allow";
      Action = [
        "s3:GetObject"
        "s3:PutObject"
        "s3:DeleteObject"
      ];
      Resource = "arn:aws:s3:::${stateBucket}/${statePath}/*";
    }
  ];

  state-statements = ddb ++ s3;
in
{
  buckets = {
    state = {
      name = stateBucket;
      path = statePath;
    };
    ami = {
      name = amiBucket;
      path = amiPath;
    };
    log = {
      name = logBucket;
      path = logPath;
    };
  };
  dynamo = {
    state = {
      name = stateTable;
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
