# FRONTEND
resource "kubernetes_service" "frontend-service" {
  metadata {
    name      = "frontend-service"
    namespace = var.namespace
    labels = {
      app = var.frontend_app_label
      tier = "frontend"
    }
  }
  spec {
    selector = {
      test = var.frontend_app_label
    } 
    port {
      name        = "http"
      port        = 8080
      target_port = 80
      node_port   = 30080
      protocol    = "TCP"
    }
    type = "NodePort"
    # Potenzialmente inutile per app Stateless
    session_affinity = "ClientIP"
  }
}



# BACKEND
resource "kubernetes_service" "backend_service" {
  metadata {
    name      = "backend-service"
    namespace = var.namespace
    labels = {
      app = var.backend_app_label
    }
  }
  spec {
    selector = {
      app = var.backend_app_label
    }
    port {
      name        = "http"
      port        = 3000
      target_port = 3000
      protocol    = "TCP"
    }
    # Accesso interno al cluster
    type = "ClusterIP"
  }
}
