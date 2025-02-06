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

## Setup services

For each camera setup a service similar to the example below

```
[Unit]
Description=CAM1
After=network.target

[Service]
ExecStart=/home/jan/recorder/recorder.sh 192.168.1.101 CAM1 /mnt/usb2
Restart=always
User=jan
Group=jan
Environment=MY_VAR=myvalue

[Install]
WantedBy=multi-user.target
```

## Configure crontab 

add something similar to below to your crontab

```
0 * * * * /home/jan/recorder/cleaner.sh >> /home/jan/recorder/cleaner.log
30 * * * * /home/jan/recorder/cleaner.sh /mnt/usb2 >> /home/jan/recorder/cleaner2.log
```


## Setup NGINX

Install nginx and edit `/etc/nginx/sites-available/default`
after line `root /var/www/html;` add something like

```
        location ^~ /cam1/ {
            root "/mnt/usb2";
            autoindex on;
        }
        location ^~ /cam2/ {
            root "/mnt/usb1";
            autoindex on;
        }

        location ^~ /cam3/ {
            root "/mnt/usb1";
            autoindex on;
        }
```
