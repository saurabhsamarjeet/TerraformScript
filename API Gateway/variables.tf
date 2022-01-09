variable "REGION" {
  type = string
  default = "us-east-1"
}

variable "APIGATEWAY_NAME" {
  type    = string
  default = "UPIDGeneratorApi"
}

variable "HTTP_METHOD_GET" {
  type    = string
  default = "GET"

}


variable "VPC_LINK_ID" {
  type    = string
  default = "qvu03l"
}

variable "SWAGGER_BASE_URL" {
  type    = string
  default = "https://upideneratorApi-sys.pbtrack-test.com/swagger"
}
variable "BASE_URL" {
  type    = string
  default = "https://upideneratorApi-sys.pbtrack-test.com/swagger"
}
