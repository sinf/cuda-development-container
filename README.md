# Basic cuda development container

Here is a minimal Dockerfile that installs the mandatory cuda boilerplate stuff to run pytorch/llamafile/whatever.

# Set up CDI on host (outside container):

1. install nvidia-container-toolkit-base if available (smaller) or nvidia-container-toolkit
2. sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
3. nvidia-ctk cdi list  --> should output nvidia.com/gpu=xyz

# Build and run this container

Use this container as an interactive shell where cuda is available. The home directory is a persistent volume (install venv+stuff there), and the 3 directories from this repository (rodata, src, output) are mounted there also. See run.sh contents for details
```
./run.sh
```

