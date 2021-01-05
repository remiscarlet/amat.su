version: '3'

volumes:
  conf:
  vhost:
  html:
  dhparam:
  certs:
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: '/home/amatsu/certs/'
  static:

services:
  amatsu-prod:
    container_name: amatsu-prod
    image: "gcr.io/${gcr_project}/${gcr_image}:${gcr_prod_tag}"
    labels:
      com.centurylinklabs.watchtower.enable: "True"
    expose:
      - ${env_amatsu_prod_port}
    environment:
      - IS_PRODUCTION=1
      - PYTHONUNBUFFERED=1
      - GUNICORN_LOG_LEVEL=info
      - GUNICORN_USER=${env_gunicorn_user}
      - VIRTUAL_HOST=${env_amatsu_prod_host}
      - VIRTUAL_PORT=${env_amatsu_prod_port}
      - LETSENCRYPT_HOST=${env_amatsu_prod_host}
    volumes:
      - vhost:/app/nginx/vhost.d
      - static:/app/static

  amatsu-dev:
    container_name: amatsu-dev
    image: "gcr.io/${gcr_project}/${gcr_image}:${gcr_dev_tag}"
    labels:
      com.centurylinklabs.watchtower.enable: "True"
    expose:
      - ${env_amatsu_dev_port}
    environment:
      - IS_PRODUCTION=0
      - PYTHONUNBUFFERED=1
      - GUNICORN_LOG_LEVEL=debug
      - GUNICORN_USER=${env_gunicorn_user}
      - VIRTUAL_HOST=${env_amatsu_dev_host}
      - VIRTUAL_PORT=${env_amatsu_dev_port}
      - LETSENCRYPT_HOST=${env_amatsu_dev_host}
    volumes:
      - vhost:/app/nginx/vhost.d
      - static:/app/static

  nginx-proxy:
    container_name: nginx-proxy
    image: jwilder/nginx-proxy
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - static:/app/static:ro
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - certs:/etc/nginx/certs:ro
      - vhost:/etc/nginx/vhost.d:ro
      - html:/usr/share/nginx/html
      - dhparam:/etc/nginx/dhparam
    depends_on:
      - amatsu-prod
      - amatsu-dev

  letsencrypt-nginx-proxy:
    container_name: letsencrypt
    image: jrcs/letsencrypt-nginx-proxy-companion
    environment:
      - DEFAULT_EMAIL=${env_amatsu_admin_email}
      - ACME_CA_URI=${env_acme_ca_uri}
      - NGINX_PROXY_CONTAINER=nginx-proxy
    volumes:
      - static:/app/static:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - certs:/etc/nginx/certs:rw
      - vhost:/etc/nginx/vhost.d
      - html:/usr/share/nginx/html
      - dhparam:/etc/nginx/dhparam
    depends_on:
      - nginx-proxy

  watchtower:
    container_name: watchtower
    image: containrrr/watchtower
    environment:
      - WATCHTOWER_LABEL_ENABLE=True
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    depends_on:
      - letsencrypt-nginx-proxy
