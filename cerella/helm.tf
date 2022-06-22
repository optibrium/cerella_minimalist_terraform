#
# @author GDev
# @date November 2021
#

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.environment.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.environment.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.environment_auth.token
  }
}

resource "helm_release" "ingress" {
  name       = "ingress"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  version    = var.ingress-version
  depends_on = [aws_autoscaling_group.workers]

  set {
    name  = "controller.replicaCount"
    value = "1"
  }

  set {
    name  = "controller.healthStatus"
    value = "true"
  }

  set {
    name  = "controller.kind"
    value = "daemonset"
  }

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }

  set {
    name  = "controller.service.httpPort.nodePort"
    value = var.cluster-ingress-port
  }

  set {
    name  = "prometheus.create"
    value = true
  }

  set {
    name  = "controller.enableLatencyMetrics"
    value = true
  }

  set {
    name  = "controller.setAsDefaultIngress"
    value = true
  }

  set {
    name  = "controller.config.entries.proxy-body-size"
    value = "2000m"
  }

  set {
    name  = "controller.config.entries.client-max-body-size"
    value = "2000m"
  }

  set {
    name  = "controller.config.entries.max-body-size"
    value = "2000m"
  }

  set {
    name  = "controller.config.entries.proxy-read-timeout"
    value = "300s"
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.prometheus-version
  depends_on = [aws_autoscaling_group.workers]
}

resource "kubernetes_namespace" "blue" {
  metadata {
    annotations = {
      name = "blue"
    }

    labels = {
      purpose = "blue"
    }

    name = "blue"
  }
}

resource "kubernetes_default_service_account" "blue" {
  metadata {
    namespace = "blue"
  }
  image_pull_secret {
    name = "blue-regcred"
  }
}

resource "kubernetes_secret" "blue-docker-logins" {
  metadata {
    name      = "blue-regcred"
    namespace = "blue"
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "https://index.docker.io/v1/" = {
          auth = "${base64encode("${var.registry_username}:${var.registry_password}")}"
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_namespace" "green" {
  metadata {
    annotations = {
      name = "green"
    }

    labels = {
      purpose = "green"
    }

    name = "green"
  }
}

resource "kubernetes_default_service_account" "green" {
  metadata {
    namespace = "green"
  }
  image_pull_secret {
    name = "green-regcred"
  }
}

resource "kubernetes_secret" "green-docker-logins" {
  metadata {
    name      = "green-regcred"
    namespace = "green"
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "https://index.docker.io/v1/" = {
          auth = "${base64encode("${var.registry_username}:${var.registry_password}")}"
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "helm_release" "cerella_blue" {
  name       = "blue"
  repository = "https://helm.cerella.ai"
  chart      = "cerella_blue"
  version    = var.cerella-version
  depends_on = [aws_eks_cluster.environment]

  set {
    name = "domain"
    value = var.domain
  }
}


resource "helm_release" "cerella_green" {
  name       = "green"
  repository = "https://helm.cerella.ai"
  chart      = "cerella_green"
  version    = var.cerella-version
  depends_on = [aws_eks_cluster.environment]

  set {
    name = "domain"
    value = var.domain
  }
}
