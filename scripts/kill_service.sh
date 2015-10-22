#!/bin/bash

function abort()
{
	echo "$@"
	exit 1
}

PORT=0

for i in "$@"; do
  case $i in
    -p=*|--port=*)
      PORT="${i#*=}"
    shift
    ;;
    *)
      echo "Unknown option (option: $i)"
      exit 1
    ;;
  esac
done

if [ "$PORT" -le "0" ]; then
    abort "Port cannot be less than or equal to zero (was: $PORT)"
fi

service_name="hello_${PORT}"
echo " --> Killing service (name: ${service_name})"

docker kill ${service_name}
sleep 1