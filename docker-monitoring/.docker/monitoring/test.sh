#!/bin/bash
# create certificate authority by openssl with key.pem and cert.pem
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
    > prometheus.yaml
