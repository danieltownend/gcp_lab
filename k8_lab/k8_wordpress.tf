# Adding kubernetes provider to providers.tf breaks it so leave it here
provider "kubernetes" { 
  host  = "https://${google_container_cluster.primary.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}

resource "kubernetes_deployment" "wp" {
  metadata {
    name = "wordpress"
    labels = {
      App = "frontend"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "frontend"
      }
    }
    template {
      metadata {
        labels = {
          App = "frontend"
        }
      }
      spec {
        container {
          image = "wordpress"
          name  = "wordpress"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}