data_dir = "/var/lib/consul/data"

client_addr = "0.0.0.0"
bind_addr = "0.0.0.0"

ui_config {
  enabled = true
  metrics_provider = "prometheus"
  metrics_proxy {
    base_url = "http://192.0.2.1:9090"
  }
}

server = true

advertise_addr = "192.0.2.1"

bootstrap_expect = 1

acl = {
  enabled = true
  default_policy = "deny"
  enable_token_persistence = true
}

addresses {
  dns = "0.0.0.0"
  http = "0.0.0.0"
}

ports  {
  grpc = 8502
}

telemetry {
  prometheus_retention_time = "59m"
}
