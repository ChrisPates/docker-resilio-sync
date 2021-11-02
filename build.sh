#!/usr/bin/env bash
 
docker buildx build -t elcrp96/resilio-sync:latest --platform linux/armhf,linux/arm64,linux/amd64 ./ --push
