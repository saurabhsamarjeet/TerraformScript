provider "aws" {
  region = "us-east-1"

}
resource "aws_iam_role" "dev-utp-ml-start_sagemaker_instance_role1" {
  name = var.dev-utp-ml-start_sagemaker_instance_role1
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Principal": {
"Service": "sagemaker.amazonaws.com"
},
"Action": "sts:AssumeRole"
}
]
}
EOF
}

resource "aws_iam_policy" "start-sagemaker-instance-policy1" {
  name        = var.start-sagemaker-instance-policy1
  description = "sagemaker instance start access"

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
            "Resource":"arn:aws:logs:${var.region}:${var.aws-account-number}:log-group:/aws/sagemaker*"
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

resource "aws_iam_role_policy_attachment" "utp-ml-get-inference-data-policy-attachment" {
    role = aws_iam_role.dev-utp-ml-start_sagemaker_instance_role1.name
    policy_arn = aws_iam_policy.start-sagemaker-instance-policy1.arn
}
resource "aws_sagemaker_notebook_instance" "notebook-instance" {
  name          = "my-notebook-instance"
  role_arn      = aws_iam_role.dev-utp-ml-start_sagemaker_instance_role1.arn
  lifecycle_config_name = "${aws_sagemaker_notebook_instance_lifecycle_configuration.basic_lifecycle.name}"
  instance_type = "ml.t3.large"
}
data "template_file" "instance_init" {
  template = "${file("${path.module}/template/inference_sagemaker_instance_init.sh")}"
}

resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "basic_lifecycle" {
  name     = "BasicNotebookInstanceLifecycleConfig"
  on_start = "${base64encode(data.template_file.instance_init.rendered)}"
}
