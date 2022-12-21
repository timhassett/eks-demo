resource "kubernetes_service_account" "load-balancer-controller-service-account" {
  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
        "app.kubernetes.io/name"= "aws-load-balancer-controller"
        "app.kubernetes.io/component"= "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = module.load-balancer-controller-role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

resource "helm_release" "load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  depends_on = [
    kubernetes_service_account.load-balancer-controller-service-account
  ]

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  set {
    name  = "image.repository"
    value = "${var.aws_registry_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }
}


resource "helm_release" "ingress-nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  create_namespace = true
}


resource "helm_release" "metrics-server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"
}




resource "kubectl_manifest" "cluster-autoscaler-sa" {
    yaml_body = templatefile("${path.module}/manifests/cluster-autoscaler-sa.yaml.tftpl", {role_arn = module.cluster-autoscaler-role.iam_role_arn})
}

data "kubectl_file_documents" "cluster-autoscaler-roles-docs" {
    content = file("${path.module}/manifests/cluster-autoscaler-roles.yaml")
}

resource "kubectl_manifest" "cluster-autoscaler-roles" {
    for_each  = data.kubectl_file_documents.cluster-autoscaler-roles-docs.manifests
    yaml_body = each.value
}

resource "kubectl_manifest" "cluster-autoscaler-deployment" {
    yaml_body = templatefile("${path.module}/manifests/cluster-autoscaler-deployment.yaml.tftpl", {cluster_name = module.eks.cluster_name})
}