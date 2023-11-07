{ self }:
let
  region = "ap-southeast-2";
  account-id = 372627124797;

  state-bucket = "676728e1b95-terraform";
  ami-bucket = "676728e1b96-terraform";
  state-path = "terraform/state";
  ami-path = "ami";
  state-table = "terraform-state";
  ddb = [{
    Effect = "Allow";
    Action = [
      "dynamodb:DescribeTable"
      "dynamodb:GetItem"
      "dynamodb:PutItem"
      "dynamodb:DeleteItem"
    ];
    Resource = "arn:aws:dynamodb:${region}:${
        builtins.toString account-id
      }:table/${state-table}";
  }];

  s3 = [
    {
      Effect = "Allow";
      Action = [ "s3:ListBucket" ];
      Resource = "arn:aws:s3:::${state-bucket}";
    }
    {
      Effect = "Allow";
      Action = [ "s3:GetObject" "s3:PutObject" "s3:DeleteObject" ];
      Resource = "arn:aws:s3:::${state-bucket}/${state-path}/*";
    }
  ];

  state-statements = ddb ++ s3;
in {
  buckets = {
    state = {
      name = state-bucket;
      path = state-path;
    };
    ami = {
      name = ami-bucket;
      path = ami-path;
    };
  };
  dynamo = { state = { name = state-table; }; };
  iam = { inherit state-statements; };

  inherit region account-id;
  tags = {
    # This is neat as it'll ensure we know what commit created the resource.
    # This will fail if the git tree is dirty, forcing us to be much better about
    # ensuring code is committed or removed :)
    # If you're seeing a failure here, it's because your git tree is
    # dirty. Solve that and no more errors.
    build = self.common.self.rev;
  };
}