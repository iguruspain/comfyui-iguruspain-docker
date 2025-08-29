# ComfyUI with PyTorch and SageAttention

[![GitHub Workflow](https://img.shields.io/github/actions/workflow/status/iguruspain/comfyui-iguruspain-docker/docker-publish.yml)](https://github.com/iguruspain/comfyui-iguruspain-docker/actions/workflows/docker-publish.yml)

Este proyecto proporciona una configuración Docker optimizada para ejecutar ComfyUI con aceleración GPU en Ubuntu 24.04, utilizando PyTorch y el plugin SageAttention. El contenedor está diseñado para ser eficiente y fácil de usar.

## Características principales

### 1. Rendimiento GPU optimizado (CUDA 12.8)
El contenedor está configurado para aprovechar la última versión de PyTorch con CUDA 12.8. Esto garantiza el máximo rendimiento y compatibilidad con GPUs NVIDIA modernas, permitiendo que ComfyUI y sus modelos generativos funcionen sin problemas.

### 2. Entorno limpio y aislado
Todas las dependencias de Python se instalan en un entorno virtual (`.venv`), lo que asegura que ComfyUI se ejecute en un entorno limpio y aislado, evitando conflictos con otras aplicaciones Python en el sistema.

### 3. Plugins y dependencias preconfigurados
El contenedor incluye dependencias esenciales de Python y plugins clave como ComfyUI-Manager y SageAttention. Así puedes lanzar el contenedor y trabajar de inmediato, sin instalaciones manuales adicionales.

### 4. Configuración flexible con Docker Compose
La configuración con `docker-compose.yml` simplifica el despliegue del servicio. Puedes personalizar los volúmenes para persistir modelos, salidas, entradas y workflows, así como ajustar otros parámetros del contenedor según tus necesidades.

### 5. Entrypoint personalizado
El script `entrypoint.sh` gestiona la configuración inicial del contenedor, como la creación de enlaces simbólicos para workflows, activación del entorno virtual y el lanzamiento del servidor ComfyUI.

# Instalación

## 0. Paso previo: Crear la estructura de carpetas con create_folder.sh
```bash
chmod +x create_folders.sh
./create_folders.sh ~/Docker/comfyui
```

## 1. Despliegue directo con GitHub Container Registry
```bash
export UID=$(id -u)
export GID=$(id -g)
export FOLDER=~/Docker/comfyui
docker pull ghcr.io/iguruspain/comfyui-iguruspain-docker:latest
docker run --rm -it -p 8188:8188 ghcr.io/iguruspain/comfyui-iguruspain-docker:latest
```

## 2. Acceso a la interfaz
Abre tu navegador en [http://localhost:8188](http://localhost:8188)

# Adicional

## Para construir y lanzar con Docker Compose (si quieres construir la imagen localmente)
```bash
export UID=$(id -u)
export GID=$(id -g)
export FOLDER=~/Docker/comfyui

# Construir la imagen localmente (sin cache)
docker compose build --no-cache

# Iniciar el contenedor (recrea el contenedor si es necesario)
docker compose up --force-recreate
```
