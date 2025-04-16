# Ejercicios Uso Varnish Nivel Intermedio - Varnishlog

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Ejemplos y ejercicio curso Varnish Nivel Intermedio - Varnishlog


## Ejercicio 1 – Ver todo el flujo de una solicitud
**Objetivo:** Visualizar todos los pasos que sigue una petición básica.

```bash
curl -I http://phpvarnish.local/
varnishlog -g request
```

Busca:
- `Begin`, `ReqMethod`, `ReqURL`
- `VCL_call`, `VCL_return`
- `RespStatus`, `X-Varnish`, `Age`

Entender el flujo:
- ¿La solicitud fue un HIT o un MISS?
- ¿Se usó caché o se fue al backend?
- ¿Cuánto tiempo lleva cacheado el objeto?

---

## Ejercicio 2 – Filtrar por URL específica
**Objetivo:** Enfocar logs en una ruta específica.

```bash
curl -I http://phpvarnish.local/listado.php
docker exec -it varnish varnishlog  -q 'BereqURL ~ "listado"'
```

---

## Ejercicio 3 – Ver ESI internos de una página
**Objetivo:** Observar cómo Varnish ejecuta subsolicitudes ESI.

```bash
curl -I http://phpvarnish.local/listado.php
docker exec -it varnish varnishlog -g request -q "ReqURL ~ 'bloques'"
```

Analizá cómo Varnish separa y resuelve cada `<esi:include>`.

---

## Ejercicio 4 – Determinar si fue HIT o MISS
**Objetivo:** Confirmar si la respuesta fue entregada desde la caché o no.

```bash
curl -I http://phpvarnish.local/listado.php
docker exec -it varnish varnishlog  -q 'BereqURL ~ "listado"'
```

Buscá líneas con:
- `Hit`
- `VCL_call HIT` o `MISS`
- `X-Cache: HIT` (si fue configurado)

---

## Ejercicio 5 – Ver duración del objeto en caché
**Objetivo:** Ver el `Age` y TTL efectivo.

```bash
curl -I http://phpvarnish.local/listado.php
docker exec -it varnish varnishlog  -q 'BereqURL ~ "listado"'"
```

Revisá:
- `Age`
- `TTL`
- `Cache-Control`

---

## Ejercicio 6 – Analizar una solicitud HEAD
**Objetivo:** Ver cómo maneja Varnish una solicitud HEAD.

```bash
curl -I -X HEAD http://phpvarnish.local/listado.php
docker exec -it varnish varnishlog -g request -q "ReqMethod eq 'HEAD'"
```

---

## Ejercicio 7 – Ver headers enviados por el cliente
**Objetivo:** Observar qué headers llegan a Varnish y cómo los procesa.

```bash
curl -I -H "X-Debug: true" http://phpvarnish.local/listado.php
varnishlog -g request -q "ReqHeader ~ 'X-Debug'"
```

---

## Ejercicio 8 – Comparar diferencias entre dos transacciones
**Objetivo:** Ver cómo cambia el flujo cuando una respuesta es HIT vs MISS.

```bash
# Primer request para cachear
curl -I http://phpvarnish.local/listado.php
# Segundo request (debería ser HIT)
curl -I http://phpvarnish.local/listado.php
docker exec -it varnish varnishlog  -q 'BereqURL ~ "listado"'"
```

Compará los logs: ¿hay diferencias en `Hit`, `Fetch`, `TTL`?

---

## Ejercicio 9 – Ver logs de subsolicitudes ESI con TTL distinto
**Objetivo:** Analizar cómo se manejan fragmentos con TTLs independientes.

```bash
curl -I http://phpvarnish.local/bloques/lang.php?lang=es
docker exec -it varnish varnishlog -g request -q "ReqURL ~ 'bloques'"
```

Buscá las diferencias de `TTL` entre bloques.

---

## Ejercicio 10 – Registrar un log personalizado
**Objetivo:** Aprender a generar entradas personalizadas en los 
logs para facilitar la depuración o trazabilidad.

**Paso 1:** Agregar log en tu VCL
En vcl_recv o vcl_deliver, podés escribir:

```
import std;

sub vcl_recv {
if (req.url ~ "^/(admin|login)") {
            std.log("REMAX: hola");
             return (pass);
         }
}
```

**Paso 2:** Hacer dos solicitudes

No deberia salir
```
curl -I http://phpvarnish.local/listado.php
```
Deberia salir
```
curl -I http://phpvarnish.local/admin/index.php
```
**Paso 3:** Buscar en los logs
```
varnishlog -g request -q 'VCL_Log ~ "REMAX"'
```

## Ejercicio 11 – Personalizar resultado
**Objetivo:** Personaliza el resultado de los datos que se muestran en el logs
```
docker exec -it varnish varnishlog -i Begin,ReqUrl,Link,BereqURL,RespHeader,VCL_* -g request
``` 
Ejecutar la curl con -v
```
curl -v http://phpvarnish.local/listado.php
```



## Ejercicio 12 – Rastrear subconsultas ESI por URL
**Objetivo:** Identificar cada solicitud generada por fragmentos ESI y observar cómo se resuelven individualmente.
```
docker exec -it varnish varnishlog -g request -i Begin,ReqUrl,Link,BereqURL,RespHeader,VCL_* -q "ReqURL ~ 'bloques'"
```
Ejecutar la curl con -v
```
curl -v http://phpvarnish.local/listado.php
```



