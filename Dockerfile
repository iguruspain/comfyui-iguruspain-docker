# ------------------------------------------------------------------
# Stage 1: Builder
# All heavy installations and build processes happen here.
# ------------------------------------------------------------------
FROM nvidia/cuda:12.8.0-base-ubuntu24.04 AS builder

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Installation of system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        nano \
        ffmpeg libffmpeg-nvenc-dev \
        gnupg2 \
        software-properties-common \
        git \
        build-essential \
        cmake \
        pkg-config \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv \
        sudo \
        libjpeg-dev libpng-dev libwebp-dev libtiff-dev libopenexr-dev \
        libavformat-dev libavcodec-dev libavutil-dev libswscale-dev libswresample-dev \
        libx264-dev libx265-dev libvpx-dev libfreetype6-dev \
        libgl1-mesa-dev libx11-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create user with specified UID/GID
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=1000

RUN if ! id -u ${USERNAME} >/dev/null 2>&1; then \
        useradd -m -u ${USER_UID} -g ${USER_GID} -s /bin/bash ${USERNAME}; \
    fi && \
    mkdir -p /etc/sudoers.d && chmod 755 /etc/sudoers.d && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

# Switch to the new user and set the working directory
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Copy and prepare entrypoint script and additional requirements
COPY --chown=${USERNAME}:${USERNAME} entrypoint.sh .
RUN chmod +x ./entrypoint.sh

COPY --chown=${USERNAME}:${USERNAME} additional_requirements.txt .

# Clone ComfyUI and ComfyUI-Manager
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /home/${USERNAME}/ComfyUI && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager /home/${USERNAME}/ComfyUI/custom_nodes/comfyui-manager

# Set ComfyUI as the new working directory for the next steps
WORKDIR /home/${USERNAME}/ComfyUI

# Create Python venv and install dependencies
RUN python3 -m venv .venv && \
    .venv/bin/pip install --upgrade pip

# PyTorch installation with --no-cache-dir optimization
RUN .venv/bin/pip install --no-cache-dir torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128

# Install other requirements
RUN .venv/bin/pip install --no-cache-dir \
        -r https://github.com/comfyanonymous/ComfyUI/raw/refs/heads/master/requirements.txt \
        -r https://github.com/Comfy-Org/ComfyUI-Manager/raw/refs/heads/main/requirements.txt \
        -r /home/${USERNAME}/additional_requirements.txt \
    && .venv/bin/pip list

# SageAttention 2 installation via Python script
RUN .venv/bin/python - <<'PY'
import sys
import huggingface_hub
import subprocess
import os

wheel_name = "sageattention-2.2.0-cp312-cp312-linux_x86_64.whl"

wheel_path = huggingface_hub.hf_hub_download(
    repo_id="Kijai/PrecompiledWheels",
    filename=wheel_name,
    force_download=True,
    revision="main",
)

subprocess.check_call([sys.executable, "-m", "pip", "install", wheel_path])

os.remove(wheel_path)
print(f"✓ SageAttention instalado desde {wheel_path}")
PY

# ------------------------------------------------------------------
# Stage 2: Production
# This stage is a minimal image for running the application.
# ------------------------------------------------------------------
FROM nvidia/cuda:12.8.0-runtime-ubuntu24.04

# Use the same user and UID/GID as the builder stage
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=1000

# Copy only the necessary files from the builder stage
# This includes the user's home directory with venv and ComfyUI
COPY --from=builder /home/${USERNAME} /home/${USERNAME}
COPY --from=builder /etc/sudoers.d/${USERNAME} /etc/sudoers.d/${USERNAME}

# Set permissions for the copied files
RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

# Switch to the application user
USER ${USERNAME}
WORKDIR /home/${USERNAME}/ComfyUI

# Expose the port
EXPOSE 8188

# Use the new entrypoint script to run the application
ENTRYPOINT ["/home/ubuntu/entrypoint.sh"]
