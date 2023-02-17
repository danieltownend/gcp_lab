resource "kubernetes_deployment" "ubuntu_container" {
  metadata {
    name = "ubuntu"
    labels = {
      App = "ubuntu"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "ubuntu_container"
      }
    }
    template {
      metadata {
        labels = {
          App = "ubuntu_container"
        }
      }
      spec {
        container {
          name  = "ubuntu"
          image = "ubuntu"
          stdin = true
          tty = true
          
          port {
            container_port = 22
          }
        }
      }
    }
  }
}