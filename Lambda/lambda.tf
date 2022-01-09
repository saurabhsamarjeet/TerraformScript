## Terraform Provider config
#########################################################################

    provider "aws" {
    version = ">= 2.0.0"
    region  = "${var.REGION}"

}
#########################################################################
## Terraform backend config
#########################################################################

    terraform {
    required_version = ">= 0.12.20"
    #backend "s3" {}
}

resource "aws_lambda_function" "td-utp-db-health-lambda" {
  function_name = var.INFERENCE_LAMBDA_NAME
  role          = aws_iam_role.td-utp-db-health-role.arn
  handler       = "DbHealth::Function::FunctionHandler"
  s3_bucket = var.BUCKET_NAME
  s3_key=     "db-health/s.zip"
  runtime = "dotnetcore3.1"
  kms_key_arn = aws_kms_key.td-utp-db-health-key.arn
  environment {
    variables = {
     bucketName = var.BUCKET_NAME,
     database = var.DATABASE,
     password = var.PASSWORD,
     server =   var.SERVER,
     userName = var.USER_NAME
     }
  }
    vpc_config {
       subnet_ids = var.SUBNET_IDS
       security_group_ids = [var.SECURITY_GROUP_IDS]
   }

}
resource "aws_iam_role" "td-utp-db-health-role" {
  name = var.INFERENCE_LAMBDA_ROLE_NAME
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Principal": {
"Service": "lambda.amazonaws.com"
},
"Action": "sts:AssumeRole"
}
]
}
EOF
}
resource "aws_iam_policy" "td-utp-db-health-policy" {
  name        = var.DATABASE_ACCESS_POLICY_NAME
  description = "VPC access for Datbase query execution"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource":"arn:aws:logs:${var.REGION}:${var.AWS_ACCOUNT_NUMBER}:log-group:/aws/lambda*"
        },
      {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface",
                "ec2:AssignPrivateIpAddresses",
                "ec2:UnassignPrivateIpAddresses"
            ],
            "Resource": "*"
        }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "td-utp-db-health-policy-attachment" {
    role = aws_iam_role.td-utp-db-health-role.name
    policy_arn = aws_iam_policy.td-utp-db-health-policy.arn
}

resource "aws_kms_key" "td-utp-db-health-key" {
  description = "KMS key for encrypting database credentials"
 depends_on = [aws_iam_role.td-utp-db-health-role]
  policy = <<EOF
{
    "Id": "key-consolepolicy-3",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.AWS_ACCOUNT_NUMBER}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                   "${aws_iam_role.td-utp-db-health-role.arn}"
                ]
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${aws_iam_role.td-utp-db-health-role.arn}"
                ]
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
}
  EOF

}

resource "aws_kms_alias" "a" {
  name          = "alias/EnvLambdaEnvironmentVariableEncryptionKey"
  target_key_id = aws_kms_key.td-utp-db-health-key.key_id
}
