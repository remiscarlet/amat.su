version: '3'
services:
  amatsu:
    container_name: amatsu
    image: "gcr.io/${gcr_project}/${gcr_image}:${gcr_tag}"
    expose:
      - 8000
    environment:
      - VIRTUAL_HOST=${env_amatsu_host}
      - VIRTUAL_PORT=${env_amatsu_port}
      - LETSENCRYPT_HOST=${env_amatsu_host}

  nginx-proxy:
    container_name: nginx-proxy
    image: jwilder/nginx-proxy
    ports:
      - "80:80"
      - "443:443"
    environment:
      - VIRTUAL_HOST=${env_amatsu_host}
      - VIRTUAL_PORT=${env_amatsu_port}
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - certs:/etc/nginx/certs:ro
      - vhost:/etc/nginx/vhost.d
      - html:/usr/share/nginx/html
      - dhparam:/etc/nginx/dhparam
    depends-on:
      - amatsu

  letsencrypt-nginx-proxy:
    container_name: letsencrypt
    image: jrcs/letsencrypt-nginx-proxy-companion
    volumes_from:
      - nginx-proxy
    environment:
      - DEFAULT_EMAIL=${env_amatsu_admin_email}
      - ACME_CA_URI=${env_acme_ca_uri}
      - NGINX_PROXY_CONTAINER=nginx-proxy
    volumes:
      - certs:/etc/nginx/certs:rw
      - /var/run/docker.sock:/var/run/docker.sock:ro
    depends-on:
      - nginx-proxy

volumes:
  conf:
  vhost:
  html:
  dhparam:
  certs:
