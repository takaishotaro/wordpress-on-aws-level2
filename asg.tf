module "private_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.env_code}-private"
  description = "Alow port 80 and 3306 tcp inbound to ASG instances within VPC"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.external_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "https to elb"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

# data "aws_ami" "wordpress_ami" {
#    filter {
#     name   = "image_id"
#     values = ["ami-01e80333bb3b09995"]
#   }
# }

module "autoscalling" {
  source = "terraform-aws-modules/autoscaling/aws"

  name                      = var.env_code
  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 2
  health_check_grace_period = 400
  health_check_type         = "EC2"
  vpc_zone_identifier       = data.terraform_remote_state.level1.outputs.private_subnet_id
  target_group_arns         = module.alb.target_group_arns
  force_delete              = true

  launch_template_name        = var.env_code
  launch_template             = "Launch temp example"
  update_default_version      = true
  launch_template_description = "$Latest"

  image_id        = "ami-058c26a84a10d2278"
  instance_type   = "t2.micro"
  key_name        = "main"
  security_groups = [module.private_sg.security_group_id]
  # user_data       = filebase64("user-data.sh")

  create_iam_instance_profile = true
  iam_role_name               = var.env_code
  iam_role_path               = "/ec2/"
  iam_role_description        = "iam role for ssm"
  iam_role_tags = {
    CustomIamRole = "No"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

