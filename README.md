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

Example session:
```
$ ./run.sh
+ podman build -t localhost/machinelearning .
STEP 1/10: FROM debian:12
.......
.......
STEP 10/10: CMD /bin/bash
--> Using cache 4e631bb6f5f16017749b506aaeb6abdbc255cbcde17797c92cf10db9d1a41ac3
COMMIT localhost/machinelearning
--> 4e631bb6f5f1
Successfully tagged localhost/machinelearning:latest
4e631bb6f5f16017749b506aaeb6abdbc255cbcde17797c92cf10db9d1a41ac3
+ podman volume create machinelearning_home
+ true
+ CONTAINER_USER=idiotuser
+ CONTAINER_WORKDIR=/home/idiotuser
+ '[' -z '' ']'
+ RUNAS=idiotuser:idiotuser
+ podman run --rm -it -u idiotuser:idiotuser -v ./rodata:/home/idiotuser/rodata:ro -v ./src:/home/idiotuser/src:ro -v ./output:/home/idiotuser/output:U -v model_training_home:/home/idiotuser --device nvidia.com/gpu=all localhost/machinelearning /bin/bash
idiotuser@e3325bcd76ef:~$
idiotuser@c9bc08776185:~$ ./src/setup-venv.sh
Requirement already satisfied: pip in ./venv/lib/python3.11/site-packages (25.0.1)
Requirement already satisfied: torch in /home/idiotuser/venv/lib/python3.11/site-packages (from -r requirements.txt (line 1)) (2.6.0)
Requirement already satisfied: torchvision in /home/idiotuser/venv/lib/python3.11/site-packages (from -r requirements.txt (line 2)) (0.21.0)
.......
.......
idiotuser@327ae8192f81:~$ ls
output  rodata  src  venv
idiotuser@c9bc08776185:~$ . ./venv/bin/activate
(venv) idiotuser@c9bc08776185:~$ ./src/torch_check.py
tensor([[0.0273, 0.5679, 0.4815],
        [0.6676, 0.5780, 0.6758],
        [0.8759, 0.6776, 0.9363],
        [0.3924, 0.4118, 0.8390],
        [0.2243, 0.8713, 0.6411]])
has cuda: True
(venv) idiotuser@c9bc08776185:~$
```

