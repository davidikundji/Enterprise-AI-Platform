data "aws_availability_zones" "available" {
  state = "available"
}

module "network" {
  source = "./modules/network"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  availability_zones = slice(
    data.aws_availability_zones.available.names,
    0,
    2
  )
}

module "security" {
  source = "./modules/security"

  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = module.network.vpc_id
  container_port = var.container_port
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  bedrock_inference_profile_id = var.bedrock_inference_profile_id
  bedrock_model_id             = var.bedrock_model_id
  bedrock_destination_regions  = var.bedrock_destination_regions
}

module "alb" {
  source = "./modules/alb"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  container_port        = var.container_port
  health_check_path     = var.health_check_path
}

module "ecs" {
  source = "./modules/ecs"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  repository_url = module.ecr.repository_url
  image_tag      = var.image_tag

  container_port = var.container_port
  desired_count  = var.ecs_desired_count

  private_subnet_ids    = module.network.private_subnet_ids
  ecs_security_group_id = module.security.ecs_security_group_id

  target_group_arn = module.alb.target_group_arn

  execution_role_arn = module.iam.execution_role_arn
  task_role_arn      = module.iam.task_role_arn

  bedrock_inference_profile_id = var.bedrock_inference_profile_id

  depends_on = [
    module.alb,
    module.iam
  ]
}

module "autoscaling" {
  source = "./modules/autoscaling"

  cluster_name = module.ecs.cluster_name
  service_name = module.ecs.service_name

  min_capacity = var.ecs_min_capacity
  max_capacity = var.ecs_max_capacity

  cpu_target    = var.ecs_cpu_target
  memory_target = var.ecs_memory_target
}

module "monitoring" {
  source = "./modules/monitoring"

  project_name = var.project_name
  environment  = var.environment

  cluster_name = module.ecs.cluster_name
  service_name = module.ecs.service_name

  alb_arn_suffix          = module.alb.alb_arn_suffix
  target_group_arn_suffix = module.alb.target_group_arn_suffix

  cpu_alarm_threshold    = var.cpu_alarm_threshold
  memory_alarm_threshold = var.memory_alarm_threshold
}