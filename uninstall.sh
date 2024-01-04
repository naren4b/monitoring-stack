#! /bin/bash
name=$1
default_value="demo"
name=${name:-$default_value}

docker ps | grep $name | awk '{print $1}' | xargs docker rm -f
