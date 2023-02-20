# Loadbalance to pods for port 80 (http)
resource "kubernetes_service" "lb" {
  metadata {
    name = "wordpress"
  }
  spec {
    selector = {
      
      App = "frontend"
      
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  } 

}