# Ejercicios Uso Varnish Nivel Intermedio - Varnishstat

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Ejemplos y ejercicio curso Varnish Nivel Intermedio - Varnishstat

---

## Ejercicio 1 – Ver estadísticas generales
**Objetivo:** Familiarizarse con la interfaz de `varnishstat`.

```bash
docker exec -it varnish varnishstat
```

Observá en particular:
- `MAIN.cache_hit`
- `MAIN.cache_miss`
- `MAIN.sess_conn`
- `MAIN.uptime`

---

## Ejercicio 2 – Ver estadísticas resumidas
**Objetivo:** Mostrar solo los campos más relevantes.

```bash
docker exec -it varnish varnishstat -f MAIN.cache_hit,MAIN.cache_miss
```

Hacé varias solicitudes a la misma URL para observar cómo cambian los valores:

```bash
curl -v http://phpvarnish.local/listado.php
```

---

## Ejercicio 3 – Observar impacto de un ESI
**Objetivo:** Medir cuántas subconsultas ESI se están ejecutando.

```bash
curl -v http://phpvarnish.local/listado.php
```

Luego:
```bash
docker exec -it varnish varnishstat -f MAIN.esi_requests
```

Repetí varias veces y observá cómo sube el contador.

---

## Ejercicio 4 – Medir objetos en caché
**Objetivo:** Ver cuántos objetos están activos en la caché.

```bash
docker exec -it varnish varnishstat -f MAIN.n_object
```

---

## Ejercicio 5 – Ver objetos caducados
**Objetivo:** Observar el TTL y expiración de objetos cacheados.

```bash
docker exec -it varnish varnishstat -f MAIN.n_expired
```

Esperá que caduquen objetos (de acuerdo al TTL que hayas definido) y observá cómo sube el valor.

---


