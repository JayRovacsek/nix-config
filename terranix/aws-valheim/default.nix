{ self, ... }:
let
  inherit (self.common.terraform.globals) aws;
  inherit (aws) region tags;
in {
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
    required_providers = {
      aws = {
        source = "hashicorp/aws";
        version = "4.54.0";
      };
    };
  };

  provider = {
    aws = {
      inherit region;
      default_tags = { inherit tags; };
      access_key = "\${var.AWS_ACCESS_KEY}";
      secret_key = "\${var.AWS_SECRET_KEY}";
    };
  };

  resource = {
    # Create an EC2 instance
    aws_instance.example_instance = {
      ami = "ami-0c55b159cbfafe1f0"; # Update with your desired AMI
      instance_type = "t2.micro"; # Update with your desired instance type
      # Other instance configuration...

      # Ensure the EC2 instance is stopped initially
      lifecycle = { prevent_destroy = true; };
    };

    # Create a CloudWatch Event Rule to trigger the start action
    aws_cloudwatch_event_rule = {
      start_rule = {
        name = "start_instance_weekly";
        description = "Trigger EC2 instance start once a week";

        schedule_expression =
          "cron(0 9 ? * SUN *)"; # Update with your desired start time (every Sunday at 9:00 AM UTC)

        # Specify the target for the event rule
        target = {
          arn = "\${aws_lambda_function.start_function.arn}";
          id = "start_target";
        };
      };

      # Create a CloudWatch Event Rule to trigger the stop action
      stop_rule = {
        name = "stop_instance_weekly";
        description = "Trigger EC2 instance stop once a week";

        schedule_expression =
          "cron(0 12 ? * SUN *)"; # Update with your desired stop time (every Sunday at 12:00 PM UTC)

        # Specify the target for the event rule
        target = {
          arn = "\${aws_lambda_function.stop_function.arn}";
          id = "stop_target";
        };
      };
    };

    # Create an AWS Lambda function for starting the EC2 instance
    aws_lambda_function = {
      start_function = {
        filename =
          "start_instance_lambda.zip"; # Update with the actual filename of your Lambda function code
        function_name = "start_instance_function";
        role = "\${aws_iam_role.lambda_role.arn}";
        handler = "index.lambda_handler";
        runtime = "python3.8"; # Update with your desired Lambda runtime

        # Other Lambda function configuration...
      };

      # Create an AWS Lambda function for stopping the EC2 instance
      stop_function = {
        filename =
          "stop_instance_lambda.zip"; # Update with the actual filename of your Lambda function code
        function_name = "stop_instance_function";
        role = "\${aws_iam_role.lambda_role.arn}";
        handler = "index.lambda_handler";
        runtime = "python3.8"; # Update with your desired Lambda runtime

        # Other Lambda function configuration...
      };
    };

    # Create an IAM role for the Lambda functions
    aws_iam_role = {
      lambda_role = {
        name = "lambda_execution_role";

        assume_role_policy = {
          "Version" = "2012-10-17";
          "Statement" = [{
            "Effect" = "Allow";
            "Principal" = { "Service" = "lambda.amazonaws.com"; };
            "Action" = "sts:AssumeRole";
          }];
        };
      };
    };

    # Attach necessary IAM policies to the Lambda role
    aws_iam_role_policy_attachment.lambda_policy_attachment = {
      role = "\${aws_iam_role.lambda_role.name}";
      policy_arn =
        "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole";
    };

  };
}
