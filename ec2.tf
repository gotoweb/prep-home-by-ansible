provider "aws" {
  region = local.region
}

locals {
  name   = "${replace(basename(path.cwd), "_", "-")}"
  region = "ap-northeast-2"

  tags = {
    Example    = local.name
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.0"

  name = local.name
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = false

  public_subnet_tags = {
    Name = "overridden-name-public"
  }

  tags = local.tags

  vpc_tags = {
    Name = "vpc-name"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow ssh"
  description = "allow ssh inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "bluemarble" {
  ami           = "ami-0fa722130bc79ec9b"
  instance_type = "t4g.small"
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]

  key_name = "noah"

  tags = {
    Name = "bluemarble"
  }

  user_data = "${file("multiuser.sh")}"
}