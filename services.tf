# Frontend Service
resource "kubernetes_service" "frontend-service" {
  metadata {
    name      = "frontend-service"
    namespace = var.namespace
  }
  spec {
    selector = {
      test = var.frontend_app_label
    } 
    port {
      port        = 8080
      target_port = 80
      node_port   = 30080
    }
    type = "NodePort"
  }
}

# Backend Service
resource "kubernetes_service" "backend-service" {
  metadata {
    name      = "backend-service"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = var.backend_app_label
    }
    port {
      port        = 8080
      target_port = 3000
      node_port   = 30081
    }
    type = "NodePort"
  }
}