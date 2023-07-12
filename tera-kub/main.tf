provider "kubernetes" {
  config_path    = "~/.kube/config"
}
variable "pod_names" {
  type    = list(string)
  default = ["pat-1", "pat-2", "pat-3"]
}

variable "container_names" {
  type    = list(string)
  default = ["container-1", "container-2", "container-3"]
}
resource "kubernetes_pod" "example_pods" {
  count = length(var.pod_names)

  metadata {
    name      = var.pod_names[count.index]
    namespace = "rashid"
    labels = {
      app = "toko-app"
    }
  }

  spec {
    container {
      image = "toko-ssh:v1.0"
      name  = "container-1"
    }
  }
}
# Création du service de type NodePort pour se connecter en SSH
resource "kubernetes_service" "ssh_service" {
  metadata {
    name = "ssh-service"
  }

  spec {
    selector = {
      app = "toko-app"
    }

    port {
      name       = "ssh"
      protocol   = "TCP"
      port       = 22
      target_port = 22
    }

    type = "NodePort"
  }
}
# Création du déploiement
resource "kubernetes_deployment" "my_deployment" {
  metadata {
    name = "toko-deployment"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "toko-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "toko-app"
        }
      }

      spec {
        node_selector = {
          node-role.kubernetes.io/master = ""
        }

        container {
          name  = "container-2"
          image = "toko-ssh:v1.0"
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge       = 1
        max_unavailable = 0
      }
    }
  }
}

# Création du service à partir du déploiement
resource "kubernetes_service" "my_service" {
  metadata {
    name = "toko-service"
  }

  spec {
    selector = {
      app = "toko-app"
    }

    port {
      protocol = "TCP"
      port     = 80
      target_port = 80
    }
  }
}
