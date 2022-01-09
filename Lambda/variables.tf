variable "SECURITY_GROUP_IDS" {
  type = string
  default = "sg-bbd364c9"
}

variable "SUBNET_IDS" {
  type    = list(string)
  default = ["subnet-84cfbfcf", "subnet-cfff45ab"]
}

variable "INFERENCE_LAMBDA_NAME" {
  type    = string
  default = "td-utp-db-health-lambda"
}

variable "INFERENCE_LAMBDA_ROLE_NAME" {
  type    = string
  default = "td-utp-db-health-role"
}

variable "DATABASE_ACCESS_POLICY_NAME" {
  type    = string
  default = "td-utp-db-health-policy"
}

variable "BUCKET_NAME" {
  type    = string
  default = "td-utp-db-health-lamda"
}
variable "DATABASE" {
  type    = string
  default = "Tracking1"
}
variable "PASSWORD" {
  type    = string
  default = "123"
}
variable "SERVER" {
  type    = string
  default = "10.98.1.22"
}
variable "USER_NAME" {
  type    = string
  default = "testawslambda"
}
variable "AWS_ACCOUNT_NUMBER" {
  type    = string
  default = "763296155577"
}

variable "REGION" {
  type= string
  default = "us-east-1"
}
variable "deployment-bucket-name-prefix" {
  type= string
  default = "dev-td-plt-deployment/carrier-prediction/"
}
