#!/bin/bash
# create certificate authority by openssl with key.pem and cert.pem
openssl req -x509 -nodes -newkey rsa:2048 -keyout key.pem -out cert.pem -sha256 -days 365 \
  -subj "/C=VN/ST=HoChiMinh/L=HoChiMinh/O=mac/OU=IT Department/CN=localhost"
# Create nginx config file to attach to nginx container
echo 'server { 
    listen                  443 ssl;
    listen                  [::]:443 ssl;
    server_name             localhost;
    ssl_certificate         /root/ssl/cert.pem;
    ssl_certificate_key     /root/ssl/key.pem;

    location / {
        proxy_pass "http://grafana:3000/";
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
    }
    
    error_page   500 502 503 504  /50x.html;

}
' >nginx.conf

## Create prometheus.yml file
echo 'global:
  scrape_interval: 1s
  evaluation_interval: 15s
  external_labels:
    monitor: 'Project-technical-report'

      #alerting:
      #alertmanagers:
      #- static_configs:
      #- targets:
      #      - alertmanager:9093
# Load and evaluate rules in this file every 'evaluation_interval' seconds.
#rule_files:
#  - "/alertmanager/alert.rules"

scrape_configs:
  - job_name: prometheus
    scrape_interval: 5s
    scrape_timeout: 2s
    honor_labels: true

    static_configs:
    - targets: ['prometheus:9090']
  
  - job_name: node-exporter
    scrape_interval: 5s
    scrape_timeout: 2s
    honor_labels: true

    static_configs:
    - targets: ['node-exporter:9100']

  - job_name: cadvisor
    scrape_interval: 5s
    scrape_timeout: 2s
    honor_labels: true

    static_configs:
    - targets: ['cadvisor:8080']'
>prometheus.yml

# Create docker-compose.yml file
echo 'version: "3.4"
services:
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    ports:
    - 8080:8080
    volumes:
    - /:/rootfs:ro
    - /var/run:/var/run:rw
    - /sys:/sys:ro
    - /var/lib/docker/:/var/lib/docker:ro

  prometheus:
    image: prom/prometheus:latest
    # ports:
    # - 9090:9090
    command:
    - --config.file=/etc/prometheus/prometheus.yml
    volumes:
    - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
    depends_on:
    - cadvisor

  grafana:
    image: grafana/grafana
      #ports:
      #- 4000:3000
    volumes:
    - ./data:/var/lib/grafana
    restart: always
    user: "1001"
    depends_on:
    - prometheus
  node-exporter:
    image: prom/node-exporter
    container_name: node-exporter
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - --collector.filesystem.ignored-mount-points
      - "^/(sys|proc|dev|host|etc|rootfs/var/lib/docker/containers|rootfs/var/lib/docker/overlay2|rootfs/run/docker/netns|rootfs/var/lib/docker/aufs)($$|/)"
    # ports:
    #  - 9100:9100
    restart: always
  nginx:
    image: nginx
    container_name: nginx_motinor
    volumes:
     - ./nginx.conf:/etc/nginx/conf.d/default.conf
     - ./key.pem:/root/ssl/key.pem
     - ./cert.pem:/root/ssl/cert.pem
    ports:
      - "443:443"
    depends_on:
      - grafana

' >docker-compose.yml

echo 'Docker-compose being up...'
sleep 1

for i in {3..1}; do
  echo "Ready after... $i s"
done

docker-compose up -d

IP=$(hostname -I | awk '{print $1}')
echo "Run commands to views docker container status
-   docker ps
-   Check grafana activity in webbrowser with: https://$IP
-   Login to grafana with: username/password is admin:admin
"
