# Run webapp node js  with the following steps:
cd docker-monitoring 
. run.sh

And test via browser:
http://<ip>:3000

# Setup monitoring system with grafana, prometheus, cadvisor
### Check current id user and id group
id -u
id -g
After replay id user and group in the script.
### Go to folder .docker/monitoring
```cd .docker/monitoring
    . RunallOnce.sh
```


