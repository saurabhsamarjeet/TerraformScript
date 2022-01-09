#########################################################################
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


  ###### Variable ##########

#variable "BASE_URL" {}
#variable "VPC_LINK_ID" {}
#variable "REGION" {}
#variable "HTTP_METHOD_GET" {}
#variable "APIGATEWAY_NAME" {}
#variable "SWAGGER_BASE_URL" {}

##########################
# API GateWay
##########################
    resource "aws_api_gateway_rest_api" "ApiGateway-UnifiedTrackingPlatform" {
    name = "${var.APIGATEWAY_NAME}"
    endpoint_configuration {
    types = ["REGIONAL"]
   }
 }

  ###########################
  # PROXY Resource
  ###########################
    resource "aws_api_gateway_resource" "ApiProxyResource" {
    rest_api_id = "${aws_api_gateway_rest_api.ApiGateway-UnifiedTrackingPlatform.id}"
    parent_id   = "${aws_api_gateway_rest_api.ApiGateway-UnifiedTrackingPlatform.root_resource_id}"
    path_part   = "{proxy+}"
}
  ######## GET Method For Proxy ################

    resource "aws_api_gateway_method" "ApiProxyMethodGET" {
    rest_api_id                   = "${aws_api_gateway_rest_api.ApiGateway-UnifiedTrackingPlatform.id}"
    resource_id                   = "${aws_api_gateway_resource.ApiProxyResource.id}"
    authorization                 = "NONE"
    http_method                   = "${var.HTTP_METHOD_GET}"
    api_key_required              = "false"
    request_parameters            = { "method.request.path.proxy" = true }
    }

    resource "aws_api_gateway_integration" "ApiProxyIntegrationGET" {
    depends_on               = ["aws_api_gateway_method.ApiProxyMethodGET"]
    rest_api_id              = "${aws_api_gateway_rest_api.ApiGateway-UnifiedTrackingPlatform.id}"
    resource_id              = "${aws_api_gateway_resource.ApiProxyResource.id}"
    http_method              = "${aws_api_gateway_method.ApiProxyMethodGET.http_method}"
    type                     = "HTTP_PROXY"
    integration_http_method  = "${var.HTTP_METHOD_GET}"
    uri                      = "${format("%s/{proxy}","${var.BASE_URL}")}"
    connection_type          = "VPC_LINK"
    connection_id            = "${var.VPC_LINK_ID}"

    request_parameters       = {"integration.request.path.proxy" = "method.request.path.proxy" , "integration.request.header.x-amz-requestId" = "context.requestId"}

    }

    resource "aws_api_gateway_method_response" "ApiProxyGETResponse" {
    depends_on               = ["aws_api_gateway_method.ApiProxyMethodGET", "aws_api_gateway_integration.ApiProxyIntegrationGET"]
    rest_api_id              = "${aws_api_gateway_rest_api.ApiGateway-UnifiedTrackingPlatform.id}"
    resource_id              = "${aws_api_gateway_resource.ApiProxyResource.id}"
    http_method              = "${aws_api_gateway_method.ApiProxyMethodGET.http_method}"
    status_code              = "200"

}

    resource "aws_api_gateway_integration_response" "ApiProxyIntegrationGETResponse" {
    depends_on               = ["aws_api_gateway_method_response.ApiProxyGETResponse", "aws_api_gateway_method.ApiProxyMethodGET", "aws_api_gateway_integration.ApiProxyIntegrationGET"]
    rest_api_id              = "${aws_api_gateway_rest_api.ApiGateway-UnifiedTrackingPlatform.id}"
    resource_id              = "${aws_api_gateway_resource.ApiProxyResource.id}"
    http_method              = "${aws_api_gateway_method.ApiProxyMethodGET.http_method}"
    status_code              = "${aws_api_gateway_method_response.ApiProxyGETResponse.status_code}"
    }
  #############################################################################################################################################

  ###########################
  # Swagger Resource
  ###########################
    resource "aws_api_gateway_resource" "swagger" {
    rest_api_id = "${aws_api_gateway_rest_api.ApiGateway-UnifiedTrackingPlatform.id}"
    parent_id   = "${aws_api_gateway_rest_api.ApiGateway-UnifiedTrackingPlatform.root_resource_id}"
    path_part   = "swagger"
}

    resource "aws_api_gateway_resource" "swagger_proxy" {
    rest_api_id = "${aws_api_gateway_rest_api.ApiGateway-UnifiedTrackingPlatform.id}"
    parent_id   = "${aws_api_gateway_resource.swagger.id}"
    path_part   = "{proxy+}"
    }

  ######## GET Method For Swagger ################

    resource "aws_api_gateway_method" "SwaggerMethodGET" {
    rest_api_id                   = "${aws_api_gateway_rest_api.ApiGateway-UnifiedTrackingPlatform.id}"
    resource_id                   = "${aws_api_gateway_resource.swagger_proxy.id}"
    http_method                   = "${var.HTTP_METHOD_GET}"
    authorization                 = "NONE"
    api_key_required              = "false"
    request_parameters            = {"method.request.path.proxy" = true}
    }

    resource "aws_api_gateway_integration" "SwaggerIntegrationGET" {
    depends_on               = ["aws_api_gateway_method.SwaggerMethodGET"]
    rest_api_id              = "${aws_api_gateway_rest_api.ApiGateway-UnifiedTrackingPlatform.id}"
    resource_id              = "${aws_api_gateway_resource.swagger_proxy.id}"
    http_method              = "${aws_api_gateway_method.SwaggerMethodGET.http_method}"
    type                     = "HTTP_PROXY"
    integration_http_method  = "${var.HTTP_METHOD_GET}"
    uri                      = "${format("%s/{proxy}","${var.SWAGGER_BASE_URL}")}"
    connection_type          = "VPC_LINK"
    connection_id            = "${var.VPC_LINK_ID}"

    request_parameters       = {"integration.request.path.proxy" = "method.request.path.proxy" , "integration.request.header.x-amz-requestId" = "context.requestId"}

    }

    resource "aws_api_gateway_method_response" "SwaggerGETResponse" {
    depends_on               = ["aws_api_gateway_method.SwaggerMethodGET", "aws_api_gateway_integration.SwaggerIntegrationGET"]
    rest_api_id              = "${aws_api_gateway_rest_api.ApiGateway-UnifiedTrackingPlatform.id}"
    resource_id              = "${aws_api_gateway_resource.swagger_proxy.id}"
    http_method              = "${aws_api_gateway_method.SwaggerMethodGET.http_method}"
    status_code              = "200"
    response_models = {
    "application/json" = "Empty"
    }

}

    resource "aws_api_gateway_integration_response" "SwaggerIntegrationGETResponse" {
    depends_on               = ["aws_api_gateway_method_response.SwaggerGETResponse", "aws_api_gateway_method.SwaggerMethodGET", "aws_api_gateway_integration.SwaggerIntegrationGET"]
    rest_api_id              = "${aws_api_gateway_rest_api.ApiGateway-UnifiedTrackingPlatform.id}"
    resource_id              = "${aws_api_gateway_resource.swagger_proxy.id}"
    http_method              = "${aws_api_gateway_method.SwaggerMethodGET.http_method}"
    status_code              = "${aws_api_gateway_method_response.SwaggerGETResponse.status_code}"
    response_templates = {
    "application/json" = ""
    }
    }
  #############################################################################################################################################

  ########### Out for API GATEWAY ID ############
    output "apigateway_id" {
    value = "${aws_api_gateway_rest_api.ApiGateway-UnifiedTrackingPlatform.id}"
}
