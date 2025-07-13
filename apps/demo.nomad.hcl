job "demo" {
  datacenters = ["dc1"]

  group "demo" {
    count = 3

    network {
      mode = "bridge"
    }

    consul {}

    service {
      name = "demo"
      port = 8080

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.http.rule=Host(`demo.test`)",
      ]

      connect {
        sidecar_service {
          proxy {}
        }
      }
    }

    task "server" {
      env {
        PORT    = "8080"
        NODE_IP = "${NOMAD_IP_connect_proxy_demo}"
      }

      driver = "docker"

      config {
        image = "hashicorp/demo-webapp-lb-guide"
      }
    }
  }
}
