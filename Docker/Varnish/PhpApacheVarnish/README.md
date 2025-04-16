# Container de Docker de PHP 8, Apache y Docker.
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

En esta ocasión tenemos la necesidad de tener un ambiente de trabajo de Varnish. 


## ¿Cual será el resultado final?
Luego de culminar la instalación tendrás:
* Un área de trabajo de PHP 8.2 montada en un servidor web de Apache
* Un container de Varnish
* Acceso web usando la url http://phpvarnish.local/

## Prerequisitos

* Instalar Docker version 26.0.0, build 2ae903e
* Instalar Docker Compose version v2.20.2
* Tener conocimientos básicos de los comandos de Docker (puedes echar un vistazo a esta [lista de comandos Docker](comandos_docker.md))
* Si no sabes como instalar Docker puedes inicar leyendo la documentación oficial https://docs.docker.com/engine/install/

## Instalación

- Clonar el proyecto
```
git clone git@github.com:dqblanco/help-commands.git
```
- Copiar el contenido de la carpeta `./help-commands/Docker/Varnish/PhpApacheVarnish` a la carpeta de tu proyecto

- Duplica el archivos `.env.dist` y asignale el nombre `.env`.

- Agregar al host (/etc/hosts) la siguiente linea 
```
127.0.0.1   phpvarnish.local
```

- Compilar y ejecutar los containers
```
docker-compose up --build -d
```

- Para entrar en el container workspace
```
docker-compose exec workspace bash
```

- Para entrar en el container de varnish
```
docker-compose exec varnish sh
```

Luego que los container han iniciado correctamente entra a http://phpvarnish.local/

Consultar sin Cache
http://phpvarnish.local:8080/

# Comandos utiles

## Invalidación
Desde el workspace: `docker exec -it workspace bash`
```
curl -X PURGE -H 'x-purge-token: PURGE_NOW' http://varnish/

```

## Llamar varnish desde host pasando por docker
```
docker exec -it varnish varnishlog -g request
```

Ir al [inicio](../README.md)
