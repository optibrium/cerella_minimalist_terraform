provider "aws" {
  region = local.region
}

locals {
  region = "eu-west-1"
  name   = "efs-ex-${replace(basename(path.cwd), "_", "-")}"

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Name       = local.name
    Example    = local.name
  }
}


################################################################################
# EFS Module
################################################################################

module "efs" {
  source = "terraform-aws-modules/efs/aws"
  version = "1.0.2"

  # File system
  name           = local.name
  creation_token = local.name
  encrypted      = true
  kms_key_arn    = module.kms.key_arn

  performance_mode                = "generalPurpose"
  throughput_mode                 = "bursting"

  # File system policy
  attach_policy                      = true
  bypass_policy_lockout_safety_check = false
  policy_statements = [
    {
      sid     = "Example"
      actions = ["elasticfilesystem:ClientMount"]
      principals = [
        {
          type        = "AWS"
          identifiers = [data.aws_caller_identity.current.arn]
        }
      ]
    }
  ]

  # Mount targets / security group
  mount_targets = { for k, v in toset(range(length(local.azs))) :
    element(local.azs, k) => { subnet_id = element(module.vpc.private_subnets, k) }
  }
  security_group_description = "Example EFS security group"
  security_group_vpc_id      = module.vpc.vpc_id
  security_group_rules = {
    vpc = {
      # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
      description = "NFS ingress from VPC private subnets"
      cidr_blocks = module.vpc.private_subnets_cidr_blocks
    }
  }

  # Backup policy
  enable_backup_policy = true

  # Replication configuration
  create_replication_configuration = true
  replication_configuration_destination = {
    region = "eu-west-2"
  }

  tags = local.tags
}

module "efs_default" {
  source = "../.."

  name = "${local.name}-default"

  tags = local.tags
}

module "efs_disabled" {
  source = "../.."

  create = false
}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name
  cidr = "10.99.0.0/18"

  azs             = local.azs
  public_subnets  = ["10.99.0.0/24", "10.99.1.0/24", "10.99.2.0/24"]
  private_subnets = ["10.99.3.0/24", "10.99.4.0/24", "10.99.5.0/24"]

  enable_nat_gateway      = false
  single_nat_gateway      = true
  map_public_ip_on_launch = false

  tags = local.tags
}

module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.0"

  aliases               = ["efs/${local.name}"]
  description           = "EFS customer managed key"
  enable_default_policy = true

  # For example use only
  deletion_window_in_days = 7

  tags = local.tags
}