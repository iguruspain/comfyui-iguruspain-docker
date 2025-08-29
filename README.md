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

# Installation

## 0. Preliminary Step: Create Folder Structure with create_folders.sh
```bash
chmod +x create_folders.sh
./create_folders.sh ~/Docker/comfyui
```

## 1. Direct Deployment with GitHub Container Registry
```bash
export UID=$(id -u)
export GID=$(id -g)
export FOLDER=~/Docker/comfyui
docker pull ghcr.io/iguruspain/comfyui-iguruspain-docker:latest
docker run --rm -it --gpus all -p 8188:8188 ghcr.io/iguruspain/comfyui-iguruspain-docker:latest
```

## 2. Access the Interface
Open your browser at [http://localhost:8188](http://localhost:8188)

# Additional

## To Build and Launch with Docker Compose (if you want to build the image locally)
```bash
export UID=$(id -u)
export GID=$(id -g)
export FOLDER=~/Docker/comfyui

# Build the image locally (without cache)
docker compose build --no-cache

# Start the container (recreate if necessary)
docker compose up --force-recreate
```
