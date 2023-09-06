provider "aws" {
  region = "eu-west-1"
}

##----------------------------------------------------------------------------- 
## Vpc Module call.    
##-----------------------------------------------------------------------------
module "vpc" {
  source                              = "git::git@github.com:opz0/terraform-aws-vpc.git?ref=master"
  name                                = "app"
  environment                         = "test"
  cidr_block                          = "10.0.0.0/16"
  enable_flow_log                     = true # Flow logs will be stored in cloudwatch log group. Variables passed in default.
  create_flow_log_cloudwatch_iam_role = true
}

##-----------------------------------------------------------------------------
## Subnet Module call.
##-----------------------------------------------------------------------------

module "subnets" {
  source                                         = "./../../"
  name                                           = "app"
  environment                                    = "test"
  nat_gateway_enabled                            = true
  availability_zones                             = ["eu-west-1a", "eu-west-1b"]
  vpc_id                                         = module.vpc.vpc_id
  type                                           = "public-private"
  igw_id                                         = module.vpc.igw_id
  cidr_block                                     = module.vpc.vpc_cidr_block
  ipv6_cidr_block                                = module.vpc.ipv6_cidr_block
  public_subnet_assign_ipv6_address_on_creation  = true
  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true
}
