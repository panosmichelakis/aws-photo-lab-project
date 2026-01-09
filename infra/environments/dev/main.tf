locals {
  common_tags = {
    project = var.project
    env     = var.env
  }

  api_app_source     = file("${path.root}/../../../app/api/main.py")
  lambda_source_path = "${path.root}/../../../app/lambda/handler.py"
}

module "network" {
  source              = "../../modules/network"
  project             = var.project
  env                 = var.env
  region              = var.region
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  public_subnet_cidr_2 = var.public_subnet_cidr_2
  private_subnet_cidr = var.private_subnet_cidr
  az                  = var.az
  az2                 = var.az2
  tags                = local.common_tags
}

module "security" {
  source   = "../../modules/security"
  project  = var.project
  env      = var.env
  vpc_id   = module.network.vpc_id
  app_port = var.app_port
  tags     = local.common_tags
}

module "s3" {
  source  = "../../modules/s3"
  project = var.project
  env     = var.env
  tags    = local.common_tags
}

module "dynamodb" {
  source  = "../../modules/dynamodb"
  project = var.project
  env     = var.env
  tags    = local.common_tags
}

module "lambda_processor" {
  source             = "../../modules/lambda_processor"
  project            = var.project
  env                = var.env
  bucket_name        = module.s3.bucket_name
  bucket_arn         = module.s3.bucket_arn
  table_name         = module.dynamodb.table_name
  table_arn          = module.dynamodb.table_arn
  lambda_source_path = local.lambda_source_path
  tags               = local.common_tags
}

module "alb" {
  source           = "../../modules/alb"
  project          = var.project
  env              = var.env
  vpc_id           = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
  app_port         = var.app_port
  tags             = local.common_tags
}

module "ec2_api" {
  source            = "../../modules/ec2_api"
  project           = var.project
  env               = var.env
  region            = var.region
  vpc_id            = module.network.vpc_id
  private_subnet_id = module.network.private_subnet_id
  ec2_sg_id          = module.security.ec2_sg_id
  app_port          = var.app_port
  instance_type     = var.instance_type
  bucket_name       = module.s3.bucket_name
  table_name        = module.dynamodb.table_name
  table_arn         = module.dynamodb.table_arn
  target_group_arn  = module.alb.target_group_arn
  api_app_source    = local.api_app_source
  tags              = local.common_tags
}
