module "eks" {
  source            = "terraform-aws-modules/eks/aws"
  version           = "~> 21.0"
  encryption_config = null

  name               = "devops-eks"
  kubernetes_version = "1.33"

  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }

  vpc_id = module.vpc.vpc_id

  # Worker nodes
  subnet_ids = module.vpc.public_subnets

  # EKS control-plane ENIs
  control_plane_subnet_ids = module.vpc.private_subnets

  # Kubernetes API endpoint
  endpoint_private_access = true
  endpoint_public_access  = true

  # Use our existing cluster security group
  create_security_group = false
  security_group_id     = aws_security_group.eks_cluster.id

  # Use our existing worker-node security group
  create_node_security_group = false
  node_security_group_id     = aws_security_group.eks_nodes.id

  # Use our existing EKS cluster IAM role
  create_iam_role = false
  iam_role_arn    = aws_iam_role.eks_cluster_role.arn

  # Don't create a KMS key for this cost-controlled lab
  create_kms_key = false

  # Don't enable control-plane logging for this lab
  enabled_log_types           = []
  create_cloudwatch_log_group = false

  # Give the identity creating the cluster administrator access
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    devops_nodes = {
      name = "devops-eks-nodes"

      instance_types = ["t3.small"]

      min_size     = 2
      max_size     = 2
      desired_size = 2

      # Use our existing node IAM role
      create_iam_role = false
      iam_role_arn    = aws_iam_role.eks_node_role.arn

      # Put worker nodes in the public subnets
      subnet_ids = module.vpc.public_subnets
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
