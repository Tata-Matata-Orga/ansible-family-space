What Kubernetes components are allowed to read from Consul

service discovery (read-only)

no writes

no sessions (unless justified)


# Kubernetes read-only service discovery policy

service_prefix "" {
  policy = "read"
}

node_prefix "" {
  policy = "read"
}

agent_prefix "" {
  policy = "read"
}