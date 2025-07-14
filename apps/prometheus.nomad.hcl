job "prometheus" {
  group "prometheus" {
    network {
      port "prometheus_ui" {
        static = 9090
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

    task "prometheus" {
      driver = "docker"

      config {
        image = "prom/prometheus:latest"
        args = ["--config.file=$${NOMAD_TASK_DIR}/prometheus.yml"]
        ports = ["prometheus_ui"]
      }

      service {
        name = "prometheus"
        tags = ["urlprefix-/"]
        port = "prometheus_ui"

        check {
          name     = "prometheus_ui port alive"
          type     = "http"
          path     = "/-/healthy"
          interval = "10s"
          timeout  = "2s"
        }
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
