#!/bin/bash

my_dir=$(pwd)
echo $my_dir
if [ ! "$(ls -A )" ]; then
  echo "No files in the directory. Exiting program."
  exit
fi

while true; do
  echo "Do you want to delete the data in the directory?"
  read -p "Delete file? (y/n) " answer

  if [ "$answer" == "y" ]; then
    echo "Delete data mongodb?"
    find $my_dir/.docker/data/db -type f !  -name ".gitkeep" -delete
    rm -rf $my_dir/.docker/data/db/*
    
    echo "Delete data from redis?"
    find $my_dir/.docker/data/redis -type f !  -name ".gitkeep" -delete
    rm -rf $my_dir/.docker/data/redis/*

    if find $my_dir/.docker/monitoring -name '*.pem' -print0 2>/dev/null | xargs -0 rm 2>/dev/null; then
	echo "All certificate deleted"
    else
	echo "No certificate"
    fi
    echo "Delete data monitoring"
    find $my_dir/.docker/monitoring/data/ -type f ! -name ".gitkeep" -delete
    rm -rf $my_dir/.docker/monitoring/data/*
    break
  elif [ "$answer" == "n" ]; then
    echo "The files will not be deleted."
    break
  else
    echo "Invalid input. Only y or n is accepted."
  fi
done



