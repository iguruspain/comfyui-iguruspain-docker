#!/bin/bash

# Check input folder
if [ -z "$1" ]; then
    echo "Error: Please, enter the name of target folder."
    echo "Use: $0 <nombre_de_la_carpeta>"
    exit 1
fi

FOLDER="$1"

# Create main folder and sub
mkdir -p "${FOLDER}/models"
#mkdir -p "${FOLDER}/custom_nodes"
#mkdir -p "${FOLDER}/user"
mkdir -p "${FOLDER}/input"
mkdir -p "${FOLDER}/output"
mkdir -p "${FOLDER}/workflows"

echo "Created folders in ${FOLDER}/"
