<<<<<<< HEAD
# FRONTEND
=======
# Frontend Service
>>>>>>> origin/main
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
<<<<<<< HEAD
=======
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
>>>>>>> origin/main
    type = "NodePort"
  }
}



# BACKEND
resource "kubernetes_service" "backend-service" {
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
      port        = 3000
      target_port = 3000
    }
  }
}