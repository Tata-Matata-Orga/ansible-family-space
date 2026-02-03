# What Vault is allowed to do inside Consul.

This is the most security-sensitive policy.

Includes:

kv/* (storage backend)

session/*

lock/*

minimal agent read access

Explicitly does not include:

catalog write

node write

ACL write

This enforces real least privilege.



key_prefix "vault/" {
  policy = "write"
}

session_prefix "" {
  policy = "write"
}

service_prefix "" {
  policy = "read"
}

node_prefix "" {
  policy = "read"
}

Do not give Vault wildcard admin access.
Vault should be powerful, but scoped.