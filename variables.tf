variable "namespace" {
  description = "The name of the Kubernetes namespace"
  type        = string
  default     = "tflab-ns"
}

# FRONTEND

variable "frontend_deployment_name" {
  description = "The name of the Kubernetes deployment"
  type        = string
  default     = "tflab-frontend-deploy"
}

variable "frontend_image" {
  description = "The Docker image for the frontend"
  type        = string
  default     = "nginx:1.21.6"
}

variable "frontend_app_label" {
  description = "App label for Kubernetes resources"
  type        = string
  default     = "tflab-frontend-app"
}

variable "frontend_service_label" {
  description = "Service label for frontend service"
  type        = string
  default     = "tflab-frontend-svc"
}

# BACKEND

variable "backend_deployment_name" {
  description = "The name of the Kubernetes deployment"
  type        = string
  default     = "tflab-backend-deploy"
}

variable "backend_image" {
  description = "The Docker image for the backend"
  type        = string
  default     = "paki13/tflab-backend:latest"
}

variable "backend_app_label" {
  description = "App label for Kubernetes resources"
  type        = string
  default     = "tflab-backend-app"
}

variable "backend_service_label" {
  description = "Service label for backend service"
  type        = string
  default     = "tflab-backend-svc"
}