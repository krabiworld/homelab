job "demo" {
  group "demo" {
    count = 3

    network {
      mode = "bridge"
      port "metrics" {
        to = -1
      }
    }

    consul {}

    service {
      name = "demo"
      port = 80

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.demo.rule=Host(`demo.test`)",
      ]

      connect {
        sidecar_service {
          proxy {
            expose {
              path {
                path            = "/metrics"
                protocol        = "http"
                listener_port   = "metrics"
                local_path_port = 19000
              }
            }
          }
        }
      }
    }

    service {
      name = "demo-metrics"
      port = "metrics"
    }

    task "server" {
      driver = "docker"

      config {
        image = "hashicorp/demo-webapp-lb-guide"
      }

      resources {
        memory = 64
      }

      template {
        env = true
        destination = "$${NOMAD_TASK_DIR}/.env"
        data = <<EOF
PORT = "80"
NODE_IP = "{{ env "NOMAD_IP_connect_proxy_demo" }}"
EOF
      }
    }
  }
}
