resource "kubernetes_service" "frontend-service" {
  metadata {
    name      = "frontend-service"
    namespace = var.namespace
  }
  
  spec {
    selector = {
      test = var.app_label
    }
    
    port {
      port        = 8080
      target_port = 80
      node_port   = 30080
    }
    
    type = "NodePort"
  }
}