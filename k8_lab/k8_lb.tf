resource "kubernetes_service" "lb" {
  metadata {
    name = "wordress"
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
  depends_on = [
    kubernetes_deployment.wp
    ]
}