# ComfyUI with PyTorch and SageAttention

[![GitHub Workflow](https://img.shields.io/github/actions/workflow/status/iguruspain/comfyui-iguruspain-docker/docker-publish.yml)](https://github.com/iguruspain/comfyui-iguruspain-docker/actions/workflows/docker-publish.yml)

This project provides an optimized Docker setup to run ComfyUI with GPU acceleration on Ubuntu 24.04, using PyTorch and the SageAttention plugin. The container is designed for maximum performance and ease of use with NVIDIA GPUs.

## Main Features

### 1. Optimized GPU Performance (CUDA 12.8)
The container is configured to leverage the latest version of PyTorch with CUDA 12.8. This ensures maximum performance and compatibility with modern NVIDIA GPUs, enabling ComfyUI and plugins to run efficiently.

### 2. Clean and Isolated Environment
All Python dependencies are installed in a virtual environment (`.venv`), ensuring ComfyUI runs in a clean and isolated environment, avoiding conflicts with other Python applications on your system.

### 3. Preconfigured Plugins and Dependencies
The container includes essential Python dependencies and key plugins such as ComfyUI-Manager and SageAttention. You can launch the container and start working immediately, without any extra manual installations.

### 4. Flexible Configuration with Docker Compose
The setup with `docker-compose.yml` simplifies service deployment. You can customize volumes to persist models, outputs, inputs, and workflows, as well as adjust other parameters as needed.

### 5. Custom Entrypoint
The `entrypoint.sh` script manages the initial configuration of the container, such as creating symbolic links for workflows, activating the virtual environment, and launching the ComfyUI server.

# Observations:
1. `nano` editor is included
2. `.bashrc` includes auto load virtual environment (`.venv`)
3. SageAttention v2.2.0 from [Hugging Face Kijai/PrecompiledWheels](https://huggingface.co/Kijai/PrecompiledWheels/tree/main) (`sageattention-2.2.0-cp312-cp312-linux_x86_64.whl`)
4. Persistent volumes in your own local `$HOME` folder without root permissions

# Installation

## 0. Preliminary Step: Create Folder Structure with create_folders.sh
```bash
chmod +x create_folders.sh
./create_folders.sh $HOME/Docker/comfyui #example folder
```

## 1. Direct deployment (choose mode)

- Export variables:

```bash
export UID=$(id -u)
export GID=$(id -g)
export FOLDER=$HOME/Docker/comfyui #example folder
```

- Interactive mode with automatic removal (Use this for temporary testing or debugging, container will be removed when it exits)

```bash
docker run --rm -it \
  --name comfyui-iguruspain-docker \
  --gpus all \
  -p 8188:8188 \
  -v $FOLDER/models:/home/ubuntu/ComfyUI/models:rw \
  -v $FOLDER/output:/home/ubuntu/ComfyUI/output:rw \
  -v $FOLDER/input:/home/ubuntu/ComfyUI/input:rw \
  -v $FOLDER/workflows:/home/ubuntu/workflows:rw \
  ghcr.io/iguruspain/comfyui-iguruspain-docker:latest
```
- Detached mode (Use this for running ComfyUI as a background service, container stays running after you close the terminal)

```bash
docker run -d \
  --name comfyui-iguruspain-docker \
  --gpus all \
  -p 8188:8188 \
  -v $FOLDER/models:/home/ubuntu/ComfyUI/models:rw \
  -v $FOLDER/output:/home/ubuntu/ComfyUI/output:rw \
  -v $FOLDER/input:/home/ubuntu/ComfyUI/input:rw \
  -v $FOLDER/workflows:/home/ubuntu/workflows:rw \
  ghcr.io/iguruspain/comfyui-iguruspain-docker:latest
```

## 2. Access the Interface
Open your browser at [http://localhost:8188](http://localhost:8188)
