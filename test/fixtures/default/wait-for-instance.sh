#!/bin/bash

echo "Waiting for up to 360 seconds for Ready to be ready."

for _ in {1..360}; do
  if [[ -f /etc/redis/redis.conf ]]; then
    echo "Ready is ready."
    exit 0
  else
    sleep 1
  fi
done

echo "Ready was not ready after 360 seconds!"
exit 1
