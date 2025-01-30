#!/usr/bin/bash

camip=${1:-'192.168.1.101'}
camname=${2:-'cam1'}
basepath=${3:-'/mnt/usb1'}

if [ ! -d "$basepath" ]; then
  echo "unable to find basepath: $basepath"
  exit 1
fi

record () {
  if [ $(sunwait poll 52.37N 4.89E) == "DAY" ]; then
    analogueGain=1.0
    exposureTime=0
  else
    analogueGain=10.0
    exposureTime=1000000
  fi
  daypath=$(date +"%Y-%m-%d")
  hourpath=$(date +"%H")
  extendedpath="$basepath/$camname/$daypath/$hourpath"
  imagename=$(date +"%H%M%S")_image.jpg
  mkdir -p "$extendedpath"
  curl "http://${camip}:8000/image?lensPosition=0&analogueGain=${analogueGain}&exposureTime=${exposureTime}" --output "${extendedpath}/${imagename}"
}

while true
do
  record
  sleep 10
done
