#!/usr/bin/env bash
set -euo pipefail

#if [ ! -f "/home/ubuntu/.download-complete" ] ; then
#
#echo "########################################"
#echo "[INFO] Downloading ComfyUI & Manager..."
#echo "########################################"
#
#set +e
#cd /home/ubuntu
#git clone https://github.com/comfyanonymous/ComfyUI.git
#cd /home/ubuntu/ComfyUI
#git clone https://github.com/ltdrdata/ComfyUI-Manager comfyui-manager
#set -e
#touch /home/ubuntu/.download-complete
#
#fi ;

# Symbolic link
if [ ! -f "/home/ubuntu/.link-wf" ] ; then
    if [ -d "/home/ubuntu/ComfyUI/user/default/workflows" ]; then
        # Y que la carpeta de destino del enlace simbólico también exista
        if [ -d "/home/ubuntu/workflows" ]; then
            echo "#############################################"
            echo "[INFO] Making a symbolic link to Workflows..."
            echo "#############################################"
            echo ""
            echo ""
            # Elimina el directorio original si existe, para reemplazarlo con el enlace
            rm -rf /home/ubuntu/ComfyUI/user/default/workflows
            # Crea el enlace simbólico
            ln -s /home/ubuntu/workflows /home/ubuntu/ComfyUI/user/default/workflows
            touch /home/ubuntu/.link-wf
        fi
    fi
fi

# Ensure .bashrc ends with source for venv
BASHRC="/home/ubuntu/.bashrc"
LINE="source ~/ComfyUI/.venv/bin/activate"

if ! tail -n 1 "$BASHRC" | grep -Fxq "$LINE"; then
    echo "$LINE" >> "$BASHRC"
    echo "[INFO] Added virtualenv source line to .bashrc"
fi

. /home/ubuntu/ComfyUI/.venv/bin/activate && exec python3 /home/ubuntu/ComfyUI/main.py --listen --port 8188 ${CLI_ARGS}
