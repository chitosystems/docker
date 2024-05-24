Docker App Core

sudo mkdir -p /srv/docker-main
sudo chown -R $USER:$USER /srv/docker-main

cd /srv/docker-main
git clone https://github.com/chitosystems/docker.git .
git pull

#add shh keys
nano php/root/.ssh/id_rsa
nano php/root/.ssh/id_rsa.pub

nano nginx/ssl/cert.crt
nano nginx/ssl/cert.key

vim .env 

sudo chmod 666 /var/run/docker.sock
sudo usermod -aG docker $USER

sudo systemctl start docker
sudo systemctl enable docker
docker compose up -d

#####
docker exec -t app.php bash
docker exec -t app.nginx bash
#####

docker exec -it app.php /bin/bash -c "sync_me.sh"


###### Troubleshooting #####

read the logs
docker logs app.php
docker logs app.nginx

docker logs app.nginx
