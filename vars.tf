# Variables values are defined/filled in:
#   "terraform.tfvars"
# Here is their initialization only.

variable "drone_image" {}
variable "drone_region" {}
variable "drone_server_size" {}
variable "drone_agent_size" {}
variable "drone_server_volume_name" {}
variable "drone_server_vol_snapshot_name" {}

variable "do_token" {}
variable "ssh_fingerprint" {}
variable "pub_key" {}
variable "pvt_key" {}

variable "drone_version" {}
variable "drone_domain" {}
variable "drone_github_client" {}
variable "drone_github_secret" {}
variable "drone_secret" {}
variable "drone_runners" {}

variable "github_access_token" {}
variable "plugin_secret" {}
