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