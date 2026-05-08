provider "consul" {
  address = var.consul_endpoint
  token   = var.consul_token
}

provider "vault" {
  address      = format("http://%v", var.vault_endpoint)
  token        = var.vault_token
}
