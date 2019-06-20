#!/bin/bash

# just to be sure that terraform is not too quick
sleep 5

# install new metric agent from DO
sudo apt-get purge do-agent
curl -sSL https://insights.nyc3.cdn.digitaloceanspaces.com/install.sh | sudo bash

# initial setup
mkdir /etc/drone
touch /etc/drone/docker-compose.yml

# creating docker-compose file
echo Writing docker-compose file
cat > /etc/drone/docker-compose.yml << EOF
version: '3'
services:
  drone-agent:
    container_name: drone_agent
    image: drone/agent:${DRONE_VERSION}
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    restart: always
    environment:
      - DRONE_RPC_SERVER=https://${DRONE_DOMAIN}
      - DRONE_RPC_SECRET=${DRONE_SECRET}
      - DRONE_RUNNER_CAPACITY=${DRONE_RUNNERS}
EOF

# running
echo Running Drone Agent
docker-compose -f /etc/drone/docker-compose.yml up -d
