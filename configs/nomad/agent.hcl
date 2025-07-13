data_dir  = "/var/lib/nomad/data"
bind_addr = "192.0.2.1"

acl {
  enabled = true
}

vault {
  enabled = true

  address   = "http://192.0.2.1:8200"

  default_identity {
    aud = ["vault.io"]
    ttl = "1h"
  }

  task_token_ttl = "1h"
  create_from_role = "nomad-cluster"
  token = ""
}

consul {
  token = ""

  address = "192.0.2.1:8500"

  grpc_address = "192.0.2.1:8502"

  server_auto_join = false
  client_auto_join = false

  service_identity {
    aud = ["consul.io"]
    ttl = "1h"
  }

  task_identity {
    aud = ["consul.io"]
    ttl = "1h"
  }
}

server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled       = true
}

addresses {
  http = "192.0.2.1"
  rpc  = "192.0.2.1"
  serf = "192.0.2.1"
}

plugin "docker" {
  config {
    allow_privileged = true

    volumes {
      enabled = true
    }
  }
}

telemetry {
  publish_allocation_metrics = true
}