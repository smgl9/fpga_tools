# Installation

```
sudo apt install docker
```

# Use

## commands

build image with tag
```
docker build -t vieux/apache:2.0 .
```

Pull image
```
sudo docker pull terostech/multi-simulator:1.0.1
```
Run image
```
sudo docker run -it terostech/multi-simulator:1.0.1 bash
```
list images
```
docker images
```
list containers
```
docker ps -a
```
stop coontainer
```
docker rm $(docker images -q)
```
Remove all unused objects
```
docker system prune
```
Remove all unused images
```
docker image prune -a
```
Remove all stopped containers
```
sudo docker container prune
```
docker save
```
docker save -o fedora-latest.tar fedora:latest
```
docker load
```
docker load --input fedora.tar
```

## Add your user to the docker group.
```
sudo usermod -aG docker $USER
```
