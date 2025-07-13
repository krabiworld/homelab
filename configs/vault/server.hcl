api_addr = "http://192.0.2.1:8200"
cluster_addr = "http://192.0.2.1:8201"
cluster_name = "vault"

ui = true
disable_mlock = true

listener "tcp" {
  address = "192.0.2.1:8200"
  cluster_address = "192.0.2.1:8201"
  tls_disable = true
}

storage "raft" {
  path = "/var/lib/vault/raft"
  node_id = "raft_node_1"
}

service_registration "consul" {
  token       = ""
  scheme      = "http"
  address     = "192.0.2.1:8500"
}
