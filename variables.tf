variable "namespace" {
  description = "The name of the Kubernetes namespace"
  type        = string
  default     = "tflab-ns"
}

variable "deployment_name" {
  description = "The name of the Kubernetes deployment"
  type        = string
  default     = "tflab-deploy"
}

variable "app_label" {
  description = "App label for Kubernetes resources"
  type        = string
  default     = "tflab-app"
}
