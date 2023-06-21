#!/bin/bash

VERSION="1.0"
IS_BATCH=true

set -x

# Verificar si se reciben los parametros necesarios
if [ $# == 0 ]; then
    IS_BATCH=false
elif [ $# -ne 1 ]; then
    echo "Error en llamada! Usar: $0 [número a calcular]"
    exit 1
fi

ejecutar() {
    if ! $1; then
        echo "Ingrese un número: "
        read numero
    else
        numero=$2
    fi

    # Tomamos usuarios conectados
    usuarios=$(obtener_usuarios)

    # Calculo del seno
    seno_calculado=$(calcular_seno $numero)

    # Mostrar resultado a todos los usuarios
    mostrar_resultado_a_usuarios $numero $seno_calculado $usuarios
}

calcular_seno(){
    pi=`echo "h=10;4*a(1)" | bc -l`
    seno=$(echo "s($1*$pi / 180)" | bc -l)
    seno_formateado=`printf "%.2f" $seno`
    echo "$seno_formateado"
}

obtener_usuarios(){
    who | awk '{print $1}' | sort -u
}

mostrar_resultado_a_usuarios() {
    for usuario in $3; do
        mensaje="El seno de $1 es: $2"
        echo $mensaje | write $usuario
    done
}

# Comprueba si se pasó la opción -v
if [[ $1 = "-v" ]]; then
    echo "Número de versión: $VERSION"
    echo "Formas de llamada:"
    echo "$0 - Calcula el seno del número de forma interactiva y muestra el resultado a todos los usuarios conectados"
    echo "$0 [número] - Calcula el seno del número ingresado y muestra el resultado a todos los usuarios conectados"
    exit 0
fi

ejecutar $IS_BATCH $1


