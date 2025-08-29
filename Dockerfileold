# ------------------------------------------------------------------
# 1. Base: Ubuntu 24.04 + CUDA 12.8
# ------------------------------------------------------------------
FROM nvidia/cuda:12.8.0-base-ubuntu24.04

# ------------------------------------------------------------------
# 2. Env variables
# ------------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# ------------------------------------------------------------------
# 3. Installation
# ------------------------------------------------------------------
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

# ------------------------------------------------------------------
# 4. Create user
# ------------------------------------------------------------------
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=1000

RUN if ! id -u ${USERNAME} >/dev/null 2>&1; then \
        useradd -m -u ${USER_UID} -g ${USER_GID} -s /bin/bash ${USERNAME}; \
    fi && \
    mkdir -p /etc/sudoers.d && chmod 755 /etc/sudoers.d && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# ------------------------------------------------------------------
# 5. ComfyUI + PyTorch + VENV
# ------------------------------------------------------------------
COPY --chown=${USERNAME}:${USERNAME} entrypoint.sh .
RUN chmod +x /home/${USERNAME}/entrypoint.sh

COPY --chown=${USERNAME}:${USERNAME} additional_requirements.txt .

# Clone ComfyUI and Manager
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /home/${USERNAME}/ComfyUI && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager /home/${USERNAME}/ComfyUI/custom_nodes/comfyui-manager

WORKDIR /home/${USERNAME}/ComfyUI

# Create venv and update pip.
RUN python3 -m venv .venv && \
    .venv/bin/pip install --upgrade pip

# PyTorch installation
RUN .venv/bin/pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128

# Make sure the deps fit the needs for ComfyUI & Manager
RUN .venv/bin/pip install \
        -r https://github.com/comfyanonymous/ComfyUI/raw/refs/heads/master/requirements.txt \
        -r https://github.com/Comfy-Org/ComfyUI-Manager/raw/refs/heads/main/requirements.txt \
        -r /home/${USERNAME}/additional_requirements.txt \
    && .venv/bin/pip list

#Sage Attention 2 installation
RUN .venv/bin/python - <<'PY'
import sys
import huggingface_hub
import subprocess
import os

# Wheel
wheel_name = "sageattention-2.2.0-cp312-cp312-linux_x86_64.whl"

# Download wheel
wheel_path = huggingface_hub.hf_hub_download(
    repo_id="Kijai/PrecompiledWheels",
    filename=wheel_name,
    force_download=True,
    revision="main",
)

# Install wheel with pip (Python venv)
subprocess.check_call([sys.executable, "-m", "pip", "install", wheel_path])

# Remove wheel
os.remove(wheel_path)
print(f"✓ SageAttention instalado desde {wheel_path}")
PY

# ------------------------------------------------------------------
# 6. Expose ports and ENTRYPOINT
# ------------------------------------------------------------------
EXPOSE 8188

# Final Workdir
WORKDIR /home/${USERNAME}/ComfyUI
ENV CLI_ARGS=""

#ENTRYPOINT ["/bin/bash", "-c", ". /home/${USERNAME}/ComfyUI/.venv/bin/activate && exec python3 /home/${USERNAME}/ComfyUI/main.py --listen --port 8188 ${CLI_ARGS}"]
ENTRYPOINT ["/bin/bash", "-c", ". /home/ubuntu/entrypoint.sh"]
