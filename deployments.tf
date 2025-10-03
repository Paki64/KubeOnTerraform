resource "kubernetes_deployment" "frontend" {
  metadata {
    name = var.deployment_name
    labels = {
      test = var.app_label
    }
    namespace = var.namespace
  }

  spec {
    
    selector {
      match_labels = {
        test = var.app_label
      }
    }
    template {
      metadata {
        labels = {
          test = var.app_label
        }
      }
      spec {
        container {
          image = "nginx:1.21.6"
          name  = "frontend"
          port {
            container_port = 80
          }
          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }

}