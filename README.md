# recorder
Record the images obtained from the cam_rest services

# Setup the system

This script uses sunwait. To setup sunwait execute the following
commands

```
cd  $HOME
git clone https://github.com/risacher/sunwait.git
cd sunwait
make
sudo cp sunwait /usr/local/bin
```

Install nginx

```
sudo apt update
sudo apt upgrade
sudo apt install nginx
```

## Setup services

For each camera setup a service similar to the example below

```
./setup_service.sh "192.168.1.101" cam1 /mnt/usb1
./setup_service.sh "192.168.1.102" cam2 /mnt/usb1
./setup_service.sh "192.168.1.103" cam2 /mnt/usb2
```

## Configure crontab 

add something similar to below to your crontab

```
0 * * * * /home/jan/recorder/cleaner.sh >> /home/jan/recorder/cleaner1.log
30 * * * * /home/jan/recorder/cleaner.sh /mnt/usb2 >> /home/jan/recorder/cleaner2.log
```


## Setup NGINX

Install nginx and edit `/etc/nginx/sites-available/default`
after line `root /var/www/html;` add something like

```
        location ^~ /cam1/ {
            root "/mnt/usb1";
            autoindex on;
        }
        location ^~ /cam2/ {
            root "/mnt/usb1";
            autoindex on;
        }

        location ^~ /cam3/ {
            root "/mnt/usb2";
            autoindex on;
        }
```
