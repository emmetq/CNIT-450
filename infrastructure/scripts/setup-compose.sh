sudo mkdir /opt/docker
sudo chown root:users -R /opt/docker
sudo chmod g+w -R /opt/docker
sudo tee /opt/docker/compose.yml <<EOF
services:
  arcane:
    image: ghcr.io/getarcaneapp/manager:latest
    container_name: arcane
    ports:
      - '3552:3552'
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /opt/docker/arcane-data:/app/data
      - /opt/docker/arcane-compose:/opt/docker
    environment:
      - APP_URL=http://localhost:3552
      - PUID=1000
      - PGID=1000
      - ENCRYPTION_KEY=$(openssl rand -hex 32)
      - PROJECTS_DIRECTORY=/opt/docker
    cgroup: host
    restart: unless-stopped
EOF
