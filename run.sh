#!/bin/sh
set -x

# Set up CDI on host (outside container):
# 1. install nvidia-container-toolkit-base if available (smaller) or nvidia-container-toolkit
# 2. sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
# 3. nvidia-ctk cdi list  --> should output nvidia.com/gpu=xyz

# Run this script ./run.sh
# setup venv to get pytorch or some other toolkit

podman build -t localhost/machinelearning .
podman volume create machinelearning_home || true

CONTAINER_USER=idiotuser
CONTAINER_WORKDIR=/home/$CONTAINER_USER

if [ -z "$RUNAS" ]; then
	RUNAS=$CONTAINER_USER:$CONTAINER_USER
fi

podman run --rm -it \
-u $RUNAS \
-v ./rodata:$CONTAINER_WORKDIR/rodata:ro \
-v ./src:$CONTAINER_WORKDIR/src:ro \
-v ./output:$CONTAINER_WORKDIR/output:U \
-v model_training_home:$CONTAINER_WORKDIR \
--device nvidia.com/gpu=all \
localhost/machinelearning \
/bin/bash

