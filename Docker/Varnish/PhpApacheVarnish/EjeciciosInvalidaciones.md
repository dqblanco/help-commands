# Ejercicios Uso Varnish Nivel Intermedio Invalidaciones

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Ejemplos y ejercicio curso Varnish Intermedio Invalidaciones

## Ejercicio 1 – Invalidar con Header Purge
Activar loga
```
docker exec -it varnish varnishlog -i Begin,ReqUrl,Link,BereqURL,RespHeader,VCL_* -g request
```
Ejecutar curl
```
curl -v http://phpvarnish.local/
```
Ejecutar Purgado desde el Workspace
```
curl -X PURGE  -H 'x-purge-token: PURGE_NOW' -H 'Host: phpvarnish.local'  http://varnish/
```



