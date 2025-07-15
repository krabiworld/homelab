job "demo" {
  group "demo" {
    count = 3

    network {
      mode = "bridge"

      port "http" {
        to = -1
      }

      port "metrics" {
        to = -1
      }
    }

    consul {}

    service {
      name = "demo"
      port = "http"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.demo.rule=Host(`demo.test`)",
      ]

      check {
        type     = "http"
        path     = "/"
        interval = "2s"
        timeout  = "2s"
      }

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
        ports = ["http"]
      }

      resources {
        memory = 64
      }

      template {
        env = true
        destination = "$${NOMAD_TASK_DIR}/.env"
        data = <<EOF
PORT = "{{ env "NOMAD_PORT_http" }}"
NODE_IP = "{{ env "NOMAD_IP_http" }}"
EOF
      }
    }
  }
}
