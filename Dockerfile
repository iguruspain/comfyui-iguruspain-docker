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
# 3. Installation (apt, limpieza combinada para una sola capa)
# ------------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates curl nano ffmpeg libffmpeg-nvenc-dev \
        gnupg2 software-properties-common git build-essential cmake pkg-config \
        python3 python3-dev python3-pip python3-venv sudo \
        libjpeg-dev libpng-dev libwebp-dev libtiff-dev libopenexr-dev \
        libavformat-dev libavcodec-dev libavutil-dev libswscale-dev libswresample-dev \
        libx264-dev libx265-dev libvpx-dev libfreetype6-dev \
        libgl1-mesa-dev libx11-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------
# 4. Create user
# ------------------------------------------------------------------
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=1000

RUN useradd -m -u ${USER_UID} -g ${USER_GID} -s /bin/bash ${USERNAME} || true && \
    mkdir -p /etc/sudoers.d && chmod 755 /etc/sudoers.d && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# ------------------------------------------------------------------
# 5. ComfyUI + PyTorch + VENV
# ------------------------------------------------------------------
COPY --chown=${USERNAME}:${USERNAME} entrypoint.sh additional_requirements.txt ./
RUN chmod +x entrypoint.sh

# Clone repos (una sola capa)
RUN git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git ComfyUI && \
    git clone --depth 1 https://github.com/ltdrdata/ComfyUI-Manager ComfyUI/custom_nodes/comfyui-manager

WORKDIR /home/${USERNAME}/ComfyUI

# Create venv, upgrade pip, instalar deps en una sola capa
RUN python3 -m venv .venv && \
    .venv/bin/pip install --upgrade pip && \
    .venv/bin/pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128 && \
    .venv/bin/pip install \
        -r https://github.com/comfyanonymous/ComfyUI/raw/refs/heads/master/requirements.txt \
        -r https://github.com/Comfy-Org/ComfyUI-Manager/raw/refs/heads/main/requirements.txt \
        -r /home/${USERNAME}/additional_requirements.txt && \
    .venv/bin/pip cache purge

# Sage Attention 2 (manteniendo limpio)
RUN .venv/bin/python - <<'PY'
import sys, subprocess, os
from huggingface_hub import hf_hub_download

wheel_name = "sageattention-2.2.0-cp312-cp312-linux_x86_64.whl"
wheel_path = hf_hub_download(repo_id="Kijai/PrecompiledWheels", filename=wheel_name, force_download=True)
subprocess.check_call([sys.executable, "-m", "pip", "install", wheel_path])
os.remove(wheel_path)
PY

# ------------------------------------------------------------------
# 6. Expose ports and ENTRYPOINT
# ------------------------------------------------------------------
EXPOSE 8188
ENV CLI_ARGS=""
ENTRYPOINT ["/bin/bash", "-c", ". /home/ubuntu/entrypoint.sh"]
