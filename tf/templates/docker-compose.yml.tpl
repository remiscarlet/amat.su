version: '2'
services:
  amatsu-secrets:
    container_name: amatsu-secrets
    image: "gcr.io/${gcr_project}/${gcr_secrets_image}:${gcr_tag}"
    volumes:
      - /home/amatsu/secrets/:/app/secrets/

  amatsu:
    container_name: amatsu
    image: "gcr.io/${gcr_project}/${gcr_image}:${gcr_tag}"
    expose:
      - 8000
    env_file:
      - /home/amatsu/secrets/amatsu.env
  depends-on:
    - amatsu-secrets

  nginx-proxy:
    container_name: nginx-proxy
    image: jwilder/nginx-proxy
    ports:
      - "80:80"
      - "443:443"
    env_file:
      - /home/amatsu/secrets/nginx-proxy.env
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
    env_file:
      - /home/amatsu/secrets/letsencrypt-nginx-proxy.env
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
