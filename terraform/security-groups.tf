# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster" {
  name        = "devops-eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "devops-eks-cluster-sg"
    Environment = "dev"
    Terraform   = "true"
  }
}


# EKS Worker Node Security Group
resource "aws_security_group" "eks_nodes" {
  name        = "devops-eks-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = module.vpc.vpc_id

  # Worker nodes can communicate with each other
  ingress {
    description = "Node to node communication"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  # Allow worker nodes to receive traffic from the cluster
  ingress {
    description     = "Cluster to worker nodes"
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  # Allow HTTPS communication from the cluster
  ingress {
    description     = "Cluster HTTPS communication"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  # Outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "devops-eks-nodes-sg"
    Environment = "dev"
    Terraform   = "true"
  }
}
