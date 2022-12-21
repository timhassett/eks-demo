module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "eks-cluster"
  cluster_version = "1.24"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
  

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.small"]
    use_name_prefix = false
    min_size     = 1
    max_size     = 3
    desired_size = 1
    capacity_type  = "ON_DEMAND"
  }
  
  eks_managed_node_groups = {
    ng-a = {
        name = "ng-a"
    }
    ng-b = {
      name = "ng-b"
    }
  }
  

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}


