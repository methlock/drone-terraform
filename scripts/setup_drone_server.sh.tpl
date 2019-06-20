#!/bin/bash

# just to be sure that terraform is not too quick
sleep 5

# mount volume - commands from DO instructions
mkdir -p /mnt/${DRONE_SERVER_VOLUME_NAME}
mount -o discard,defaults,noatime /dev/disk/by-id/scsi-0DO_Volume_${DRONE_SERVER_VOLUME_NAME} /mnt/${DRONE_SERVER_VOLUME_NAME}
echo "/dev/disk/by-id/scsi-0DO_Volume_${DRONE_SERVER_VOLUME_NAME} /mnt/${DRONE_SERVER_VOLUME_NAME} ext4 defaults,nofail,discard 0 0" | sudo tee -a /etc/fstab

# install new metric agent from DO
sudo apt-get purge do-agent
curl -sSL https://insights.nyc3.cdn.digitaloceanspaces.com/install.sh | sudo bash

# initial setup
mkdir /etc/drone
touch /etc/drone/docker-compose.yml
sudo ufw allow 80
sudo ufw allow 443

# creating docker-compose file
echo Writing docker-compose file
cat > /etc/drone/docker-compose.yml << EOF
version: '3'
services:
  drone-server:
    container_name: drone_server
    image: drone/drone:${DRONE_VERSION}
    ports:
      - 80:80
      - 443:443
    volumes:
      - /mnt/${DRONE_SERVER_VOLUME_NAME}/server_db:/data
      - /var/run/docker.sock:/var/run/docker.sock
    restart: always
    environment:
      - DRONE_SERVER_HOST=${DRONE_DOMAIN}
      - DRONE_SERVER_PROTO=https
      - DRONE_TLS_AUTOCERT=true
      - DRONE_GITHUB_SERVER=https://github.com
      - DRONE_GITHUB_CLIENT_ID=${DRONE_GITHUB_CLIENT}
      - DRONE_GITHUB_CLIENT_SECRET=${DRONE_GITHUB_SECRET}
      - DRONE_AGENTS_ENABLED=true
      - DRONE_RPC_SECRET=${DRONE_SECRET}
      - DRONE_USER_CREATE=username:githubusername,admin:true
      - DRONE_USER_FILTER=githubusername1,githubusername2
      - DRONE_YAML_ENDPOINT=http://drone-plugin:3000
      - DRONE_YAML_SECRET=${PLUGIN_SECRET}

  drone-plugin:
    container_name: drone-changeset-conditional
    image: microadam/drone-config-plugin-changeset-conditional
    ports:
      - 3000:3000
    environment:
      - PLUGIN_SECRET=${PLUGIN_SECRET}
      - GITHUB_TOKEN=${GITHUB_TOKEN}
EOF

# running
echo Running Drone server
docker-compose -f /etc/drone/docker-compose.yml up -d
