# Consul
resource "consul_acl_policy" "nomad_agents" {
  name  = "nomad-agents"
  rules = file("${path.module}/policies/consul/nomad-agents.hcl")
}

resource "consul_acl_token" "nomad_agents" {
  policies = [consul_acl_policy.nomad_agents.name]
}

resource "consul_acl_auth_method" "nomad_workloads" {
  type = "jwt"
  name = "nomad-workloads"
  config_json = jsonencode({
    JWKSURL          = format("http://%s/.well-known/jwks.json", var.nomad_endpoint)
    JWTSupportedAlgs = ["RS256"]
    BoundAudiences   = ["consul.io"]
    ClaimMappings = {
      nomad_namespace = "nomad_namespace"
      nomad_job_id    = "nomad_job_id"
      nomad_task      = "nomad_task"
      nomad_service   = "nomad_service"
    }
  })
}

resource "consul_acl_binding_rule" "nomad_service" {
  auth_method = consul_acl_auth_method.nomad_workloads.name
  bind_type   = "service"
  bind_name   = "$${value.nomad_service}"
  selector    = "\"nomad_service\" in value"
}

resource "consul_acl_binding_rule" "nomad_role" {
  auth_method = consul_acl_auth_method.nomad_workloads.name
  bind_type   = "role"
  bind_name   = "nomad-tasks-$${value.nomad_namespace}"
  selector    = "\"nomad_service\" not in value"
}

resource "consul_acl_policy" "nomad_tasks" {
  name  = "nomad-tasks"
  rules = file("${path.module}/policies/consul/nomad-tasks.hcl")
}

resource "consul_acl_role" "nomad_tasks_default" {
  name     = "nomad-tasks-default"
  policies = [consul_acl_policy.nomad_tasks.name]
}

# Vault
resource "vault_policy" "nomad_server" {
  name   = "nomad-server"
  policy = file("${path.module}/policies/vault/nomad-server.hcl")
}

resource "vault_token_auth_backend_role" "nomad_cluster" {
  role_name = "nomad-cluster"
  allowed_policies = ["access-tables"]
  token_explicit_max_ttl = 0
  orphan = true
  token_period = 259200
  renewable = true
}

resource "vault_token" "nomad_server" {
  policies = [vault_policy.nomad_server.name]
  ttl = "72h"
  no_parent = true
}
