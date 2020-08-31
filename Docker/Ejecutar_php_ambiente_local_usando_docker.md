
# Cómo ejecutar PHP en ambiente local usando docker

## Objetivo

Ejecutar php en ambiente local usando un container de docker

## Ambiente

* Container de docker con Php 7.3
* Ubuntu sin ningún tipo de instalación de php

## ¿Por Qué?

* En ocasiones es necesario ejecutar php en ambiente local sin entrar al container de docker. Por ejemplo cuando usamos algún plugin de **Visual Studio Code** que en su configuración requiere la ruta donde se encuentra instalado php.
* Cuando queremos usar varias versiones de php y no queremos hacer todas las instalaciones localmente.
* Cuando tenemos tiempo y empezamos a buscar algo que hacer jejejeje.

## Procedimiento

* En la ruta `/usr/bin` creamos un file llamado `php`: Ejemplo: `sudo vim /usr/bin/php`
* Agergar al archivo las siguientes lineas:

```
#!/bin/bash

docker exec -ti -w $PWD --user=nombreUsuario nombre_container php $@

```
* Agregar permisos de ejecución: `sudo chmod +x /usr/bin/php`
* Ejecutar el comando `php -version`

Ir al [inicio](../README.md)