variable "security_group_ids" {
  type = string
  default = "sg-bbd364c9"
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-84cfbfcf", "subnet-cfff45ab"]
}

variable "cloudwatch_event_rule_name" {
  type    = string
  default = "dev-utp-ml-schedule-inference-data-event"
}


variable "cloudwatch_event_target_id" {
  type    = string
  default = "dev-utp-ml-schedule-inference-data-target"
}

variable "cloudwatch_event_cron" {
  type    = string
  default = "cron(30 10 * * ? *)"
}

variable "inference_lambda_name" {
  type    = string
  default = "dev-utp-ml-get-inference-data-lambda"
}

variable "inference_lambda_role_name" {
  type    = string
  default = "dev-utp-ml-get-inference-data_role"
}

variable "sagemaker_access_policy_name" {
  type    = string
  default = "dev-utp-ml-sagemaker-access-policy"
}

variable "database_access_policy_name" {
  type    = string
  default = "dev-utp-ml-database-access-policy"
}
variable "dev-utp-ml-start_sagemaker_instance_role1" {
  type    = string
  default = "dev-utp-ml-start_sagemaker_instance_role1"
}
variable "start-sagemaker-instance-policy1" {
   type = string
   default = "start-sagemaker-instance-policy1"
}
variable "bucket-name" {
  type    = string
  default = "partnertrackingconfigurationdev"
}
variable "database" {
  type    = string
  default = "Tracking_Prod"
}
variable "password" {
  type    = string
  default = "ggg"
}
variable "server" {
  type    = string
  default = "10.98.1.45"
}
variable "user-name" {
  type    = string
  default = "tracking_prod"
}
variable "aws-account-number" {
  type    = string
  default = "763296155577"
}

variable "region" {
  type=string
  default = "us-east-1"
}
variable "deployment-bucket-name-prefix" {
  type=string
  default = "dev-td-plt-deployment/carrier-prediction/"
}
