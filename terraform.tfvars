# Digital Ocean
drone_image                = "docker-18-04"
drone_region               = "your input"
drone_server_size          = "s-1vcpu-1gb"  # 5$/m
drone_agent_size           = "s-2vcpu-4gb"  # 20$/m but droplets which costs 10$/m is also ok, depeneds on your setup
drone_server_volume_name   = "droneserver"  # volume and snapshot name - for drone database persisting
drone_server_vol_snapshot_name = "drone-server-init"  # if you don't have snapshot, remove it from drone.tf

# Secrets
do_token                = "your input"
ssh_fingerprint         = "your input"
pub_key                 = "your input"
pvt_key                 = "your input"

# Drone related
drone_version           = 1.1
drone_domain            = "your input"
drone_github_client     = "your input"
drone_github_secret     = "your input"
# encryption key for comm between server and agent
drone_secret            = "your input"
# how many runners on agent server, depends on agent server size
drone_runners           = 2

# Drone plugin - for checking if file changes
# See: https://github.com/microadam/drone-config-changeset-conditional
# This is sometginf extra, which you propably don't need. You can remove
# it from here and from "setup_drone_server.sh.tpl".
github_access_token = "your input"
plugin_secret       = "your input"
