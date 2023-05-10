#!/usr/bin/env bash

PROCESS_NAME='Netskope'
INTERVAL=0.4

while true; do
  pids=$(ps -e | grep $PROCESS_NAME | grep -v grep | awk '{print $1}')
  if [[ ! -z "$pids" ]]; then
    for pid in $pids; do
      echo -e "💀\033[0;33m Killing $PROCESS_NAME process with PID: $pid \033[0m"
      sudo kill -9 "$pid"
    done
  else
    echo -e "🙃\033[0;32m $PROCESS_NAME not running, nothing to kill\033[0m"
  fi
  sleep $INTERVAL
done
