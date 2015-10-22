#!/bin/bash

function abort()
{
	echo "$@"
	exit 1
}

CONTAINER_HOST="$(/sbin/ifconfig eth0 | grep 'inet\ ' | cut -d: -f2 | awk '{ print $2}')"
DIRECTORY_HOST="${CONTAINER_HOST}"
PORT=0
VERSION=1

for i in "$@"; do
  case $i in
    -d=*|--directory-host=*)
      DIRECTORY_HOST="${i#*=}"
    shift
    ;;
    -p=*|--port=*)
      PORT="${i#*=}"
    shift
    ;;
    -v=*|--version=*)
      VERSION="${i#*=}"
    shift
    ;;
    *)
      echo "Unknown option (option: $i)"
      exit 1
    ;;
  esac
done

echo " --> Starting service (version: ${VERSION}, port: ${PORT})"

if [ "$PORT" -le "0" ]; then
    abort "Port cannot be less than or equal to zero (was: $PORT)"
fi

ID=`docker run -d\
    -p ${PORT}:8080\
    -e mapped_port=${PORT}\
    -e dw_directory_host=${DIRECTORY_HOST}\
    -name hello_${PORT}\
    --add-host dockerhost:${CONTAINER_HOST}\
    quay.io/datawire/bakerstreet-hello:v${VERSION}`
sleep 1

echo " --> Launched container (id: ${ID})"
