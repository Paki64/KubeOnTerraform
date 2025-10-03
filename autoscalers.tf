# Frontend HPA
resource "kubernetes_horizontal_pod_autoscaler_v2" "frontend_hpa" {
  metadata {
    name      = "frontend-hpa"
    namespace = var.namespace
  }
  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = var.frontend_deployment_name
    }
    min_replicas = 2
    max_replicas = 4
    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 50
        }
      }
    }
  }
}



# BACKEND
resource "kubernetes_horizontal_pod_autoscaler_v2" "backend_hpa" {
  metadata {
    name      = "backend-hpa"
    namespace = var.namespace
  }
  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = var.backend_deployment_name
    }
    min_replicas = 2
    max_replicas = 6
    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 50
        }
      }
    }
  }
}