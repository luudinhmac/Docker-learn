- Docker Container là một môi trường được ảo hóa và hoạt động trong quá trình run-time

# Các lệnh cơ bản trong docker
## Kiểm tra version docker
```
docker --version
```
## Thông tin hệ thống docker
```
$ docker info
```
## Kiểm tra các image đang có trong máy
```
$ docker images
$ docker image ls
```
## Tải docker image từ hub.docker.com về máy (pull docker image)
```
$ docker pull docker_image_name:tag_name
```
Ví dụ:
```
$ docker pull ubuntu:latest
$ docker pull ubuntu:18.04
```
## Kiểm tra tất cả các container đã được tạo trong máy
```
$ docker ps -a
```
## Kiểm tra các container đang chạy (container sẽ được bật hoặc tắt (stop-start))
```
$ docker ps 
```
## Tạo docker container
### Không đặt tên container
Container được tạo ra có tên bất kỳ
```
$ docker run -it docker_image_name /bin/bash 
```
### Có đặt tên:
```
$ docker run -it --name test docker_image_name /bin/bash 
```
### Một số tham số thêm vào khi tạo docker container.
```
-v path-in-host:path-in-container  (ánh xạ thư mục máy host vào container)
--volumes-from other-container-name (nhận chia sẻ thư mục đã ánh xạ từ container khác)
-p public-port:target-port (container có cổng ngoài public ánh xạ vào cổng trong target-port của container)
--restart=always (Thiết lập để docker tự khởi động container)
--rm  (xóa container sau khi thoát container)
```
### Lựa chọn GPU (Không dùng hoặc máy không có GPU thì không cần quan tâm)
```
$ docker run -it --rm --gpus '"device=1,2"' docker_image_name /bin/bash
```
### cho phép chạy tất cả các resource gpu
```
$ docker run -it --rm --gpus all docker_image_name /bin/bash 
```
### Docker Volumes
Project của chúng ta được tạo ở 1 thư mục trong container. Nếu thư mục này không được mount ra ngoài thì khi container bị xóa đồng nghĩa với việc  
project của chúng ta cũng bay hơi. Do đó khi tạo container cần thiết mount thư mục ở trong container ra máy vật lý.  
Hiểu đơn giản là container và máy vật lý dùng chung 1 thư mục. 
#### Kiểm tra danh sách volume
```
$ docker volume ls
```
#### Tạo volume
```
$ docker volume create <volume_name>
```
#### Xem thông tin chi tiết volume
```
$ docker volume inspect <volume_name>
```
```
$ docker run -it --rm -v path_directory_in_host:path_directory_in_container docker_image_name /bin/bash 
```
Trước dấu ":" là đường dẫn ở máy vật lý, sau dấu ":" là đường dẫn trong container  
Ví dụ mình muốn mount thư mục /home/dev trong container vào thư mục /home/macld/dev ở trên máy vật lý của mình thì mình làm như sau:
```
$ docker run -it --rm -v /home/macld/dev:/home/dev docker_image_name /bin/bash 
```

### Network
#### Kiểm tra danh sách network
```
$ docker network ls
```
#### Tạo docker network
```
$ docker network create --driver bridge <network_name>
```
#### Kiểm tra chi tiết docker network
```
$ docker network inspect <network_name>
```
#### Xóa network
```
$ docker rm <network_name>
```
#### Kết nối network vào một container
```
$ docker network connect <type_network> <network_name>
$ docker network connect brigde my_network
```
```
$ docker run -it --rm -p port_in_your_machine:port_in_container docker_image_name /bin/bash 
```
Ví dụ: 
```
$ docker run -it --rm -p 8001:8000 docker_image_name /bin/bash 
```
Thì điều này có nghĩa là: Một service của các bạn đang chạy ở port 8000 trong container, một ứng dụng khác gọi IP_address:8001 thì service của các bạn được gọi  
Mới học hoặc chỉ dev thông thường thì các bạn cứ để cho mình như sau: (Đỡ phải mount)
```
$ docker run -it --rm --network host docker_image_name /bin/bash 
```

## Stop docker container: Tắt
```
$ docker stop container_name (or container id)
```
## Start docker container: Bật
```
$ docker start container_name (or container id)
```
## Khởi động lại một container
```
$ docker restart container
```

## Attach vào container
Có 2 cách:
```
$ docker attach container_name
$ docker exec -it container_name /bin/bash 
```
## Commit docker container thành docker image
```
$ docker commit docker_container_name docker_image_name:tag
```
Ví dụ: Mình có 1 container là macld_ubuntu
```
$ docker commit macld_ubuntu ubuntu:18.04_installed_lib
```
## Push docker image
Nếu các bạn muốn đẩy image lên dockerhub thì cần tạo 1 tài khoản dockerhub  
Ví dụ mình có tài khoản: luudinhmac thì khi commit container mình làm như sau  
```
$ docker commit mac_ubuntu luudinhmac/ubuntu:18.04_installed_lib
```
Tạo 1 repository trên dockerhub có tên: ubuntu
Sau đó, bạn login docker tại terminal:
```
$ docker login
# Sau đó nhập user_name, password
```
Để push image bạn thực hiện câu lệnh
```
$ docker push luudinhmac/ubuntu:18.04_installed_lib
```

## Có 2 Khái niệm đê không được nhầm lẫn
1. Dockerfile: là file để tạo ra 1 docker image
2. Docker-compose: Là file dùng để tạo 1 hoặc nhiều container
