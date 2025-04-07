
# Comandos Docker
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Los títulos serán lo suficientemente descriptivos, así evitamos largas descripción. 

## Listar container

```
docker ps 
```

## Ingresar a un container

```
docker exec -ti  docker_container bash
```

## Eliminar todos los Container
```
docker rm $(docker ps -a -q)
```

## Detener y eliminar todos los  Container
```
docker rm $(docker stop $(docker ps -a -q))
```
## Reiniciar servicio Docker
```
sudo service docker restart
```
## Copiar archivo a un container
```
docker cp /path_backup/miArchivo.sql id_container:/home/
```

## Descargar archivo de un container
```
docker cp id_container:/home/miArchivo.sql /miRuta/
```

Ir al [inicio](../README.md)