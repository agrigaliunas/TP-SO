#!/bin/bash

VERSION="1.0"

# Comprueba si se pasó la opción -v
if [[ $1 = "-v" ]]; then
    echo "Número de versión: $VERSION"
    echo "Formas de llamada:"
    echo "$0"
    exit 0
fi

# Verificar si se reciben los parametros necesarios
if [ $# -ne 0 ]
then
    echo "Error en llamada! Usar: $0 sin argumentos"
    exit 1
fi


while true; do
    clear
    echo "Menú:"
    echo "1. Mostrar procesos asociados a un usuario"
    echo "2. Calcular el seno de un número"
    echo "3. Salir"
    echo

    read -p "Seleccione una opción: " opcion

    case $opcion in
        1)
            bash procesos.sh
            read -p "Presione Enter para continuar..."
            ;;
        2)
            read -p "Ingrese un número: " numero
            while ! [[ $numero =~ ^[0-9]+$ ]]; do
                echo "Ingrese un número: "
                read numero
            done
            chmod +x funcion_seno.sh
	    ./funcion_seno.sh $numero
            read -p "Presione Enter para continuar..."
            ;;
        3)
            echo "Saliendo del programa..."
            break
	    ;;
        *)
            echo "Opción inválida. Inténtelo nuevamente."
            read -p "Presione Enter para continuar..."
            ;;
    esac
done

