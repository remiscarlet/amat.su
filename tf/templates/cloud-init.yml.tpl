#cloud-config

users:
- name: amatsu
  uid: 2000
  groups: docker

write_files:
- path: /home/amatsu/docker-compose.yml
  permissions: 0755
  owner: amatsu
  content: |
${indent(4, docker_compose_content)}

- path: /etc/systemd/system/amatsu-compose.service
  permissions: 0645
  owner: root
  content: |
${indent(4, amatsu_daemon_content)}

runcmd:
- iptables -A INPUT -p tcp -j ACCEPT
- systemctl daemon-reload
- systemctl enable --now --no-block amatsu-compose.service
