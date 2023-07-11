provider "kubernetes" {
  config_path    = "/Exercice-application/tera-kub"
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
