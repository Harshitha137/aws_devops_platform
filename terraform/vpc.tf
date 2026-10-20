module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "devops-vpc"
  cidr = "10.0.0.0/16"

  azs                     = ["ap-south-1a", "ap-south-1b"]
  public_subnets          = ["10.0.0.0/20", "10.0.16.0/20"]
  private_subnets         = ["10.0.32.0/20", "10.0.48.0/20"]
  public_subnet_names     = ["devops-vpc-public-1", "devops-vpc-public-2"]
  private_subnet_names    = ["devops-vpc-private-1", "devops-vpc-private-2"]
  map_public_ip_on_launch = true
  enable_nat_gateway      = false
  enable_vpn_gateway      = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
