job "traefik" {
  group "traefik" {
    network {
      mode = "bridge"

      port "http" {
        static = 80
        to = 80
      }
      port "https" {
        static = 443
        to = 443
      }
    }

    service {
      name = "traefik"
      port = "http"
      provider = "consul"

      connect {
        native = true
      }
    }

    consul {}

    task "traefik" {
      driver = "docker"

      config {
        image = "traefik:latest"
        ports = ["http", "https"]
        args = ["--configFile", "$${NOMAD_TASK_DIR}/static.yml"]
      }

      template {
        data = <<EOF
api:
  insecure: false
  dashboard: true

log:
  level: DEBUG

ping:
  manualRouting: true

providers:
  consul:
    endpoints:
      - unix://{{ env "NOMAD_ALLOC_DIR" }}/tmp/consul_http.sock
    rootKey: nomad-workload/default/traefik
    token: {{ env "CONSUL_TOKEN" }}

  consulCatalog:
    endpoint:
      address: unix://{{ env "NOMAD_ALLOC_DIR" }}/tmp/consul_http.sock
      scheme: http
    serviceName: traefik
    connectAware: true
    connectByDefault: true
    exposedByDefault: false

entryPoints:
  http:
    address: :80

  https:
    address: :443
EOF

        destination = "$${NOMAD_TASK_DIR}/static.yml"
      }

      resources {
        cpu = 150
        memory = 384
      }
    }
  }
}