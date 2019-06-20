# PROVIDER - DigitalOcean - simple enough
provider "digitalocean" {
    token = "${var.do_token}"
}


# TEMPLATES - this is "mount" for scripts and envs/variables which are passed in
data "template_file" "drone_server_setup" {
  template = "${file("${path.module}/scripts/setup_drone_server.sh.tpl")}"
  vars {
    DRONE_VERSION            = "${var.drone_version}"
    DRONE_GITHUB_CLIENT      = "${var.drone_github_client}"
    DRONE_GITHUB_SECRET      = "${var.drone_github_secret}"
    DRONE_SECRET             = "${var.drone_secret}"
    DRONE_DOMAIN             = "${var.drone_domain}"
    DRONE_SERVER_VOLUME_NAME = "${var.drone_server_volume_name}"
    GITHUB_TOKEN             = "${var.github_access_token}"
    PLUGIN_SECRET            = "${var.plugin_secret}"
  }
}
data "template_file" "drone_agent_setup" {
  template = "${file("${path.module}/scripts/setup_drone_agent.sh.tpl")}"
  vars {
    DRONE_VERSION  = "${var.drone_version}"
    DRONE_DOMAIN   = "${var.drone_domain}"
    DRONE_SECRET   = "${var.drone_secret}"
    DRONE_RUNNERS  = "${var.drone_runners}"
  }
}


# VOLUME
data "digitalocean_volume_snapshot" "volume-snapshot" {
  name = "${var.drone_server_vol_snapshot_name}"
}
resource "digitalocean_volume" "drone-server-volume" {
  name                    = "${var.drone_server_volume_name}"
  region                  = "${var.drone_region}"
  size                    = 1  // one GB is enough for drone database
  snapshot_id             = "${data.digitalocean_volume_snapshot.volume-snapshot.id}"
  description             = "Volume for drone server. Holds drone database and stuff."
}


# DRONE SERVER
resource "digitalocean_droplet" "drone-server" {
  image = "${var.drone_image}"
  name = "tf-drone-server"
  region = "${var.drone_region}"
  size = "${var.drone_server_size}"
  private_networking = true
  ssh_keys = ["${var.ssh_fingerprint}"]
  volume_ids = ["${digitalocean_volume.drone-server-volume.id}"]
  connection {
      user = "root"
      type = "ssh"
      private_key = "${file(var.pvt_key)}"
      timeout = "2m"
  }
  provisioner "remote-exec" {
      inline = ["${data.template_file.drone_server_setup.rendered}"]
  }
}


# DRONE AGENT1 - Copy this section for new agent (and change its number)
resource "digitalocean_droplet" "drone-agent-1" {
  image = "${var.drone_image}"
  name = "tf-drone-agent-1"
  region = "${var.drone_region}"
  size = "${var.drone_agent_size}"
  private_networking = true
  ssh_keys = ["${var.ssh_fingerprint}"]
  connection {
      user = "root"
      type = "ssh"
      private_key = "${file(var.pvt_key)}"
      timeout = "2m"
  }
  provisioner "remote-exec" {
      inline = ["${data.template_file.drone_agent_setup.rendered}"]
  }
}
