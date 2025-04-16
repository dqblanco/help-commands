# Ejercicios Uso Varnish Nivel Intermedio Invalidaciones

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Ejemplos y ejercicio curso Varnish Intermedio Invalidaciones

## Ejercicio 1 – Invalidar con Header Purge
Activar log
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

## Ejercicio 2 – Agregar xkey al header listado.php
Agregar header a listado.php
```
header('xkey: listado-inmueble');
```
Activar log
```
docker exec -it varnish varnishlog  -i Begin,ReqUrl,Link,BereqURL,RespHeader,VCL_* -q "ReqURL ~ 'listado'"
```
Ejecutar curl
```
curl -v http://phpvarnish.local/listado.php
```


## Ejercicio 3 – Agregar xkey dinamico al header de las ESI dentro del listado
Agregar header en bloques/item.php
```
<?php
header('Surrogate-Control: content="ESI/1.0"');
header(sprintf('xkey: item-%s', $_GET['id'] ));
?>
```
Incluir ESI en listado.php
```
<esi:include src="bloques/item.php?id=1" />
<esi:include src="bloques/item.php?id=2" />
```
Activar log
```
docker exec -it varnish varnishlog -g request -i Begin,ReqUrl,Link,BereqURL,RespHeader,VCL_* -q "ReqURL ~ 'listado'"
```
Ejecutar curl
```
curl -v http://phpvarnish.local/listado.php
```


## Ejercicio 4 – Ajustar Varnish e invalidar item especifico
**Objetivo:** Preparar varnish y código para invalidar un tah especifico 

Asignar TTL de 10s a todos los contenidos por defecto
```
set beresp.ttl = 10s;
set beresp.http.Cache-Control = "public, max-age=10";
```

Asignar a los bloques ESI un TTL de 60s

```
if (bereq.url ~ "^/bloques/") {
      set beresp.http.Cache-Control = "public, max-age=60";
      set beresp.ttl = 60s;
}

```
Abrir log agrupados por request

```
docker exec -it varnish varnishlog -g request -i Begin,ReqUrl,Link,BereqURL,RespHeader,VCL_* -q "ReqURL ~ 'listado'"
```

Abrir log sin agrupar por request
```
docker exec -it varnish varnishlog  -i Begin,ReqUrl,Link,BereqURL,RespHeader,VCL_* -q "ReqURL ~ 'listado'"
```

Ejecutar curl
```
curl -v http://phpvarnish.local/listado.php
```
Ejecutar invalidación del listado principal desde el workspace
```
curl -X PURGEKEYS http://varnish/ -H "Host: phpvarnish.local"   -H "xkey-purge: listado-inmueble"
```
Ejecutar invalidación de un item individual desde el workspace
```
curl -X PURGEKEYS http://varnish/ -H "Host: phpvarnish.local"   -H "xkey-purge: item-6"
```

## Ejercicio 5 – Comparar XKey-Purge vs. XKey-SoftPurge
*Objetivo:* Ver la diferencia entre eliminar completamente y expirar suavemente objetos cacheados.

Ejecutar curl
```
curl -v http://phpvarnish.local/listado.php
```

Ejecutar un XKey-SoftPurge
```
curl -X PURGEKEYS http://varnish/ -H "Host: phpvarnish.local" -H "xkey-softpurge: item-6"
```

Luego observá:
```
curl -v http://phpvarnish.local/listado.php
```

Debés ver Age > 0 y X-Cache: HIT, porque Varnish aún entrega desde caché si hay grace.


Ejecutar un XKey-Purge
```
curl -X PURGEKEYS http://varnish/ -H "Host: phpvarnish.local"  -H "xkey-purge: item-6"
```
Ahora hacé el mismo curl y deberías ver:
```
curl -v http://phpvarnish.local/listado.php
```
Debés ver
X-Cache: MISS
Age: 0

Esto demuestra que softpurge expira suavemente, y purge elimina completamente.

## Ejercicio 6 – Invalidar multiples contenidos

curl del listado
```
curl -v http://phpvarnish.local/listado.php
```
Ejecutar un XKey-Purge
```
curl -X PURGEKEYS http://varnish/ -H "Host: phpvarnish.local"  -H "xkey-purge: item-6 item-5"
```

## Ejercicio 7 – Invalidar desde código PHP usando cURL
**Objetivo:** Ejecutar invalidaciones directamente desde tu app backend.
En /admin crea el archivo invalidador.php

```
<?php
    $ch = curl_init('http://varnish/');
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PURGEKEYS');
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Host: phpvarnish.local',
        'xkey-purge: item-'.$_GET['id'],
    ]);
    curl_exec($ch);
    curl_close($ch);
```

Ejecuta 
http://phpvarnish.local/admin/invalidador.php?id=5


# Ejercicio 8 – Invalidar en cascada objetos relacionados
**Objetivo:** Invalidar contenido relacionado a un mismo recurso (detalles, listados, etc).

Crear archivo detalle.php
```
<?php
include 'header.php';
header('Surrogate-Control: content="ESI/1.0"');
header('xkey: detalle-inmueble item-'.$_GET['id']);
?>

<!DOCTYPE html>
<html lang="en">
<?php include 'head.php'; ?>
<body>
<?php include 'body_header.php'; ?>
<main>
    <section>
        <table>
            <tr>
                <td>
                    <h1>Detalle <?php echo $_GET['id']?> </h1>
                </td>
            </tr>
            <tr>
                <td class="left">
                    <h2>Mi variable: <?php echo rand(1,100) ?></h2>
                </td>
                <td class="right">

                </td>
            </tr>
        </table>


    </section>
</main>
<?php include 'body_footer.php'; ?>


<script src="js/script.js"></script>
</body>
</html>

```
Abrir Detalle
http://phpvarnish.local/detalle.php?id=6

Abrir Listado
http://phpvarnish.local/listado.php

Invalidar Item
http://phpvarnish.local/admin/invalidador.php?id=6

Volver a refrescar el detalle y el listado

