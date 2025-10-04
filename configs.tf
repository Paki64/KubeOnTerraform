# FRONTEND
resource "kubernetes_config_map" "frontend_config" {
  metadata {
    name      = "frontend-config"
    namespace = var.namespace
  }

  data = {
    "nginx.conf" = <<-EOT
      server {
        listen 80;
        server_name _;
        
        root /usr/share/nginx/html;
        index index.html;

        # Frontend routes
        location / {
          try_files $uri $uri/ /index.html;
        }

        # Proxy per le API del backend
        location /api/ {
          proxy_pass http://backend-service:3000/api/;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection 'upgrade';
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_cache_bypass $http_upgrade;
          proxy_connect_timeout 60s;
          proxy_send_timeout 60s;
          proxy_read_timeout 60s;
        }

        # Health check endpoint
        location /health {
          access_log off;
          return 200 "healthy\n";
          add_header Content-Type text/plain;
        }
      }
    EOT
    
    "default.conf" = <<-EOT
      upstream backend {
        server backend-service:3000;
      }
    EOT
  }
}
