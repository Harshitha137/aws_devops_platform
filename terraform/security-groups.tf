# ==========================================
# EKS Cluster Security Group
# ==========================================

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


# ==========================================
# EKS Worker Node Security Group
# ==========================================

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


# ==========================================
# Worker Nodes → EKS Control Plane
# TCP 443
# ==========================================

resource "aws_vpc_security_group_ingress_rule" "nodes_to_cluster" {
  security_group_id            = aws_security_group.eks_cluster.id
  referenced_security_group_id = aws_security_group.eks_nodes.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}


# ==========================================
# EKS Control Plane → Worker Nodes
# TCP 443
# ==========================================

resource "aws_vpc_security_group_ingress_rule" "cluster_to_nodes_https" {
  security_group_id            = aws_security_group.eks_nodes.id
  referenced_security_group_id = aws_security_group.eks_cluster.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}


# ==========================================
# EKS Control Plane → Worker Nodes
# TCP 1025-65535
# ==========================================

resource "aws_vpc_security_group_ingress_rule" "cluster_to_nodes" {
  security_group_id            = aws_security_group.eks_nodes.id
  referenced_security_group_id = aws_security_group.eks_cluster.id

  from_port   = 1025
  to_port     = 65535
  ip_protocol = "tcp"
}
