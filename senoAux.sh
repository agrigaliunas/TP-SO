#!/bin/bash

# Verificar si el parametro fue proporcionado
if [ -z "$1" ]
then
  echo "Error: Debes proporcionar un número como parámetro."
  exit 1
fi

# Calcular el seno del número utilizando bc
seno=$(echo "s($1)" | bc -l)

# Enviar el resultado a todos los usuarios
for usuario in $(cut -d: -f1 /etc/passwd)
do
  echo "El seno de $1 es $seno" | write $usuario
done

exit 0
