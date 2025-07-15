job "prometheus" {
  group "prometheus" {
    network {
      mode = "bridge"

      port "http" {
        to = -1
      }

      port "metrics" {
        to = -1
      }
    }

    restart {
      attempts = 2
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    ephemeral_disk {
      size = 300
    }

    consul {}

    service {
      name = "prometheus"
      port = "http"

      tags = [
        "urlprefix-/",
        "traefik.enable=true",
        "traefik.http.routers.prometheus.rule=Host(`prometheus.test`)",
      ]

      check {
        name     = "prometheus_ui port alive"
        type     = "http"
        path     = "/-/healthy"
        interval = "10s"
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

    task "prometheus" {
      driver = "docker"

      config {
        image = "prom/prometheus:latest"
        args = ["--config.file=$${NOMAD_TASK_DIR}/prometheus.yml", "--web.listen-address=:$${NOMAD_PORT_http}"]
        ports = ["http"]
      }

      template {
        destination = "$${NOMAD_TASK_DIR}/prometheus.yml"

        data = <<EOH
global:
  scrape_interval:     5s

scrape_configs:
  - job_name: consul-connect-proxy
    scheme: http
    static_configs:
      - targets: [
{{- $first := true }}
{{- range services }}
  {{- if .Name | contains "-metrics" }}
    {{- $instances := service .Name }}
    {{- range $instances }}
      {{- if not $first }}, {{ end }}"{{ .Address }}:{{ .Port }}"
      {{- $first = false }}
    {{- end }}
  {{- end }}
{{- end }}]
EOH
      }
    }
  }
}
