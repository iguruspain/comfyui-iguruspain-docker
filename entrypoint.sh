#!/usr/bin/env bash
set -euo pipefail

# This script is moved into the final image, so the original download logic is not needed.

# Symbolic link
if [ ! -f "/home/ubuntu/.link-wf" ] ; then
    if [ -d "/home/ubuntu/ComfyUI/user/default/workflows" ]; then
        if [ -d "/home/ubuntu/workflows" ]; then
            echo "#############################################"
            echo "[INFO] Making a symbolic link to Workflows..."
            echo "#############################################"
            echo ""
            echo ""
            rm -rf /home/ubuntu/ComfyUI/user/default/workflows
            ln -s /home/ubuntu/workflows /home/ubuntu/ComfyUI/user/default/workflows
            touch /home/ubuntu/.link-wf
        fi
    fi
fi

# Activate the Python virtual environment and execute the ComfyUI server
. /home/ubuntu/ComfyUI/.venv/bin/activate && exec python3 /home/ubuntu/ComfyUI/main.py --listen --port 8188 ${CLI_ARGS}
