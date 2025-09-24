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

# Preinstall some nodes
if [ ! -f "/home/ubuntu/.preinsnodes" ] ; then
    if [ -d "/home/ubuntu/ComfyUI/custom_nodes/comfyui-manager" ]; then
        echo "#############################################"
        echo "[INFO] Preinstalling basic nodes..."
        echo "#############################################"
        echo ""
        echo ""
        current=`pwd`
        . /home/ubuntu/ComfyUI/.venv/bin/activate
        cd /home/ubuntu/ComfyUI/custom_nodes/comfyui-manager
        python3 cm-cli.py install "ComfyUI-Crystools"
        python3 cm-cli.py install "ComfyUI-Custom-Scripts"
        python3 cm-cli.py install "rgthree-comfy"
        python3 cm-cli.py install "ComfyUI-KJNodes"
        python3 cm-cli.py install "ComfyUI-Easy-Use"
        python3 cm-cli.py install "ComfyUI_essentials"
        python3 cm-cli.py install "comfyui-tooling-nodes"
        python3 cm-cli.py install "ComfyUI-GGUF"
        python3 cm-cli.py install "ComfyUI-nunchaku"
        cd $current
        touch /home/ubuntu/.preinsnodes
    fi
fi

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
