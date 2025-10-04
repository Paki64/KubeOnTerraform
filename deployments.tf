# FRONTEND
resource "kubernetes_deployment" "frontend" {
  metadata {
    name = var.frontend_deployment_name
    labels = {
      test = var.frontend_app_label
      tier = "frontend"
    }
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        test = var.frontend_app_label
      }
    }
    template {
      metadata {
        labels = {
          test = var.frontend_app_label
          tier = "frontend"
        }
      }
      spec {
        container {
          image = var.frontend_image
          name  = "frontend"
          port {
            container_port = 80
            name           = "http"
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
          env {
            name  = "BACKEND_URL"
            value = "http://backend-service:3000"
          }
          env {
            name  = "API_BASE_URL"
            value = "/api"
          }
          volume_mount {
            name       = "nginx-config"
            mount_path = "/etc/nginx/conf.d/default.conf"
            sub_path   = "nginx.conf"
          }
          liveness_probe {
            http_get {
              path = "/health"
              port = 80
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            timeout_seconds       = 3
            failure_threshold     = 3
          }
          readiness_probe {
            http_get {
              path = "/health"
              port = 80
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 3
          }
        }
        volume {
          name = "nginx-config"
          config_map {
            name = kubernetes_config_map.frontend_config.metadata[0].name
          }
        }
      }
    }
  }
  depends_on = [
    kubernetes_config_map.frontend_config
  ]
}



# BACKEND
resource "kubernetes_deployment" "backend" {
  metadata {
    name = var.backend_deployment_name
    labels = {
      app = var.backend_app_label
    }
    namespace = var.namespace
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = var.backend_app_label
      }
    }
    template {
      metadata {
        labels = {
          app = var.backend_app_label
        }
      }
      spec {
        container {
          image = var.backend_image
          name  = "backend"
          port {
            container_port = 3000
            name          = "http"
          }
          # NODE_ENV set as production
          env {
            name  = "NODE_ENV"
            value = "production"
          }
          # PORT set as 3000 (to match container_port)
          env {
            name  = "PORT"
            value = "3000"
          }
          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
          liveness_probe {
            http_get {
              path = "/health"
              port = 3000
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 3
            failure_threshold     = 3
          }
          readiness_probe {
            http_get {
              path = "/ready"
              port = 3000
            }
            initial_delay_seconds = 10
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 3
          }
        }
      }
    }
  }
}