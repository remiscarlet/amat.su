[Unit]
Description=Runs docker-compose for Amatsu, Nginx, Letsencrypt
Requires=docker.service network-online.target
After=docker.service network-online.target

[Service]
User=amatsu
Environment="HOME=/home/amatsu"
WorkingDirectory=/home/amatsu
ExecStartPre=/usr/bin/docker-credential-gcr configure-docker
ExecStartPre=/usr/bin/docker pull gcr.io/${gcr_project}/${gcr_image}:${gcr_tag}
ExecStart=/usr/bin/docker run \
  --rm \
  -v "/var/run/docker.sock:/var/run/docker.sock:ro" \
  -v "/home/amatsu/:/amatsu/" \
  -v "/home/amatsu/.docker:/root/.docker:ro" \
  -w="/home/amatsu/" \
  docker/compose:1.24.0 up
ExecStop=/usr/bin/docker stop amatsu
Restart=on-failure
RestartSec=10
[Install]
WantedBy=multi-user.target
