sudo apt-get update
sudo apt-get -y install redis-server
sudo cp /etc/redis/redis.conf /etc/redis/redis.conf_default
sudo sed -i s/port\ 6379/port\ ${port}/g /etc/redis/redis.conf
sudo sed -i s/bind\ 127.0.0.1\ ::1/bind\ 0.0.0.0/g /etc/redis/redis.conf
sudo systemctl restart redis-server
