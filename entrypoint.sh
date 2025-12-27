#!/usr/bin/env bash
set -euo pipefail

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

# Install some custom nodes using ComfyUI-Manager CLI if not already installed
# if [ ! -f "/home/ubuntu/.custom-nodes-installed" ] ; then
#     echo "#############################################"
#     echo "[INFO] Installing custom nodes..."
#     echo "#############################################"
#     echo ""
#     echo ""
#     . /home/ubuntu/ComfyUI/.venv/bin/activate
#     #install nodes from custom_nodes.txt using ComfyUI-Manager cli
#     #https://github.com/Comfy-Org/ComfyUI-Manager/blob/main/docs/en/cm-cli.md
#     python3 /home/ubuntu/ComfyUI/custom_nodes/comfyui-manager/cm-cli.py install $(sed '/^\s*$/d' /home/ubuntu/custom_nodes.txt)
#     touch /home/ubuntu/.custom-nodes-installed
# fi

echo "#############################################"
echo "[INFO] Starting ComfyUI..."
echo "#############################################"
# Ensure .bashrc ends with source for venv
BASHRC="/home/ubuntu/.bashrc"
LINE="source ~/ComfyUI/.venv/bin/activate"

if ! tail -n 1 "$BASHRC" | grep -Fxq "$LINE"; then
    echo "$LINE" >> "$BASHRC"
    echo "[INFO] Added virtualenv source line to .bashrc"
fi

. /home/ubuntu/ComfyUI/.venv/bin/activate && exec python3 /home/ubuntu/ComfyUI/main.py --listen --port 8188 ${CLI_ARGS}
