#cloud-config

users:
- name: amatsu
  uid: 2000
  groups: docker

write_files:
- path: /etc/systemd/system/configure-firewall.service
  permissions: 0644
  owner: root
  content: |
    ${indent(4, configure_firewall_content)}

- path: /etc/systemd/system/amatsu-compose.service
  permissions: 0645
  owner: root
  content: |
    ${indent(4, amatsu_daemon_content)}

- path: /home/amatsu/docker-compose.yml
  permissions: 0755
  owner: amatsu
  content: |
    ${indent(4, docker_compose_content)}

- path: /home/amatsu/watchtower_config.json
  permissions: 0644
  owner: amatsu
  content: |
    ${indent(4, watchtower_config_content)}


runcmd:
- sudo -u amatsu mkdir -p /home/amatsu/certs
- systemctl daemon-reload
- systemctl enable --now --no-block amatsu-compose.service
