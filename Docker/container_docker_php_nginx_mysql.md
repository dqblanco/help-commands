
# Container de Docker de PHP 8, Nginx y Mysql

En ocasiones tenemos la necesidad de tener un ambiente de trabajo de php limpio para iniciar un proyecto nuevo o 
simplemente para experimentar nuevos comandos. 

Tratare de explicar la instalación del modo más simple posible.

## ¿Cual será el resultado final?
Luego de culminar la instalación tendrás:
* Un área de trabajo de PHP 8.2 montada en un servidor web de Nginx
* Un container de Mysql 
* Acceso web usando la url http://envphp.local

## Prerequisitos 

* Instalar Docker version 26.0.0, build 2ae903e
* Instalar Docker Compose version v2.20.2 
* Tener conocimientos básicos de los comandos de Docker (puedes echar un vistazo a esta [lista de comandos Docker](comandos_docker.md))
* Si no sabes como instalar Docker puedes inicar leyendo la documentación oficial https://docs.docker.com/engine/install/


## Instalación

1. Clonar el proyecto
```
git clone git@github.com:dqblanco/help-commands.git
```
2. Copiar la carpeta el interno de lo que esta en la carpeta `./help-commands/Docker/EnvPHP/` a la carpeta de tu proyecto

Ejemplo
```
cd ~/Documents/Projects/
mkdir myproject
cp -R  ~/Documents/Projects/help-commands/Docker/EnvPHP/* ~/Documents/Projects/myproject/
```
Dentro de la carpeta myproject deberas tener la carpeta docker

3. Entra a la carpeta docker de tu proyecto
```
cd ~/Documents/Projects/myproject/docker
```

4. Duplica el archivo  **.env.dist** cambiando el nombre por  **.env**
```
cp .env.dist .env
```

5Agregar nuevo hosts **/etc/hosts**:
```
sudo vim /etc/hosts
127.0.0.1    envphp.local
```

6. Iniciar container
```
docker compose up -d
```

Si todo esta bien deberias poder ver la ejecución del index.php en la url http://envphp.local/

Para entrar al container
```
docker exec -it envphp-workspace bash
```











Ir al [inicio](../README.md)