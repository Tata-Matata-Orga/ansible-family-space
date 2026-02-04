# What Vault is allowed to do inside Consul.
# the most security-sensitive policy.

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




# Vault Consul storage backend policy

key_prefix "" {
  policy = "write"
}

session_prefix "" {
  policy = "write"
}

agent_prefix "" {
  policy = "read"
}


## Vault does not register services in the current design. It does not have Consul agent for now
# So for Vault: no agent, no local registration, no catalog services
# Therefore: Vault policy has no agent_prefix, has no service_prefix

# At the moment, Vault talks only to catalog-independent APIs, such as:
# /v1/kv/..., /v1/session/create, /v1/lock/...
# These go directly to Consul servers, do not involve agent-local state, do not require agent_prefix or service_prefix


### LEADER ELECTION and Consul as storage backend + SESSIONS

# Vault’s leader election (when using Consul as storage) is implemented on top of Consul sessions and locks.
# Vault does not have its own independent leader-election mechanism in this mode.
# If Consul is the storage backend, Consul is part of Vault’s HA control plane.
# Leader election for Vault is answering the quesion: Which Vault instance is allowed to be active right now? 
# Only one Vault instance is allowed to mutate Vault’s internal state.
# That includes: writing secrets, updating leases, revoking tokens, rotating keys, modifying auth backends
# The leadership is enforced via a lock. Works even with one Vault node
# It creates a Consul session (PUT /v1/session/create), acquires a lock in Consul KV (Only one Vault instance can acquire this lock), 
# periodically renews the session. If renewal stops → lock is released automatically
# If the active Vault crashes, is killed, loses network, Consul session expires, Consul automatically releases the lock
# another Vault instance can acquire it
