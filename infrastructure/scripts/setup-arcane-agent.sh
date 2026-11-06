sudo mkdir /opt/docker
sudo chown root:users -R /opt/docker
sudo chmod g+w -R /opt/docker
echo -n "Enter Agent Token: " 
read AGENT_API_TOKEN
echo -n "Enter Manager URL: " 
read MANAGER_API_URL
sudo tee /opt/docker/compose.yml <<EOF
services:
  arcane-edge-agent:
    image: ghcr.io/getarcaneapp/agent:latest
    container_name: arcane-edge-agent
    restart: unless-stopped
    environment:
      - EDGE_AGENT=true
      - EDGE_TRANSPORT=auto
      - AGENT_TOKEN=${AGENT_API_TOKEN}
      - MANAGER_API_URL=${MANAGER_API_URL}
	    - PUID=1000
	    - PGID=1000
	    - PROJECTS_DIRECTORY=/opt/docker
      - ENCRYPTION_KEY=$(openssl rand -hex 32)
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro
      - /opt/docker/arcane-data:/app/data
      - /opt/docker/arcane-compose:/opt/docker
    cgroup: host
EOF
