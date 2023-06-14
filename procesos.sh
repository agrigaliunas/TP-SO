#!/bin/bash

VERSION="1.0"

# Comprueba si se pasó la opción -v
if [[ $1 = "-v" ]]; then
    echo "Número de versión: $VERSION"
    echo "Formas de llamada:"
    echo "$0 - Muestra los procesos para un usuario dado de forma interactiva."
    echo "$0 -t - Muestra los procesos para todos los usuarios."
    exit 0
fi

# Verificar si se reciben los parametros necesarios
if [ $# -gt 1 ]; then
    echo "Error en llamada! Usar: $0 [-t]"
    exit 1
fi

mostrar_procesos() {
    local user=$1
    local ps_list=$(ps -u $user --no-headers)
    local ps_count=$(echo "$ps_list" | wc -l)
    local ptys_count=$(echo "$ps_list" | awk '{print $2}' | sort | uniq | wc -l)

    if [ "$ps_count" -eq 0 ]; then
        echo "El usuario $user no tiene procesos en ejecución."
    else
        echo "Usuario: $user"
        echo "$ps_list" | awk '{printf "tty/pty %s Proceso %s - %s - %s\n", $2, $1, $3, $4}'
        echo "Total de $ps_count procesos en $ptys_count ttys/ptys"
    fi
}

mostrar_todos_los_procesos() {
    for user in $(awk -F: '{print $1}' /etc/passwd); do
        mostrar_procesos $user
    done
    echo "Total de procesos en el sistema: $(ps aux --no-headers | wc -l)"
}

pedir_usuario() {
    while true; do
        read -p "Introduce un nombre de usuario: " user
        if id -u $user >/dev/null 2>&1; then
            mostrar_procesos $user
            break
        else
            echo "El usuario $user no existe. Por favor, inténtalo de nuevo."
        fi
    done
}

if [ "$1" == "-t" ]; then
    mostrar_todos_los_procesos
else
    pedir_usuario
fi

