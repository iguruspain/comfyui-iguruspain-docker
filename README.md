# ComfyUI with PyTorch and SageAttention

This project provides an optimized Docker configuration for running ComfyUI with GPU acceleration on Ubuntu 24.04, utilizing PyTorch and the SageAttention plugin. The container is designed to be efficient, lightweight, and easy to use, leveraging best practices from the community.

## Key Features

### 1. Optimized GPU Performance (CUDA 12.8)
The container is configured to leverage the latest PyTorch version with CUDA 12.8. This ensures maximum performance and compatibility with modern NVIDIA GPUs, allowing ComfyUI and its generative models to run at the highest possible speed.

### 2. Isolated and Clean Environment
All Python dependencies are installed in a virtual environment (`.venv`), which ensures that ComfyUI runs in a clean and isolated environment. This prevents conflicts with other Python applications on the host system and maintains a consistent runtime environment.

### 3. Preconfigured Plugins and Dependencies
The container comes pre-installed with essential Python dependencies and key plugins like ComfyUI-Manager and SageAttention. This means you can launch the container and start working immediately without the need for additional manual installations.

### 4. Flexible Configuration with Docker Compose
The `docker-compose.yml` configuration simplifies service deployment. You can easily customize volumes to persist models, outputs, inputs, and workflows, as well as adjust other container parameters like command-line arguments.

### 5. Custom Entrypoint
The `entrypoint.sh` script manages the initial container setup, such as creating symbolic links for workflows, and is responsible for activating the virtual environment and launching the ComfyUI server. This automates the startup process and ensures the container is always ready for use.

# Install
## 0. Pre-Intall step: Create folder structure with create_folder.sh
```bash
chmod +x create_folders.sh
./create_folders.sh ~/Docket/comfyui
```
## 1a. Deploy directly with:
```bash
export UID=$(id -u)
export GID=$(id -g)
export FOLDER=~/Docker/comfyui
aquiloquesea
```

## 1b. Compose build and up (if you want to build the image)
```bash
export UID=$(id -u)
export GID=$(id -g)
export FOLDER=~/Docker/comfyui
docker compose build --no-cache
docker compose up --force-recreate
```
