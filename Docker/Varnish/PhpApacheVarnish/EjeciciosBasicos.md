# Ejercicios Uso Varnish
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Ejemplos y ejercicio curso Varnish   


# Modificar el TTL solo para imágenes
**Objetivo:** Servir imágenes desde la caché durante más tiempo que el resto del contenido.
```
sub vcl_backend_response {
    if (bereq.url ~ "\.(png|jpg|jpeg|gif|webp)$") {
            set beresp.ttl = 30s;
            #set beresp.http.Cache-Control = "public, max-age=30";
            #No se cachea en el browser
            set beresp.http.Cache-Control = "no-store";

        } else {
            set beresp.ttl = 10s;
    }
}
```
## Verificación
```
curl -I http://phpvarnish.local/img/varnish-bunny.png
```

# Agregar header X-Cache con HIT/MISS
**Objetivo:** Ver si la respuesta vino desde caché o del backend.
```
sub vcl_hit {
    set req.http.X-Cache = "HIT";
    return (deliver);
}

sub vcl_miss {
    set req.http.X-Cache = "MISS";
    return (fetch);
}

```
**En vcl_deliver:**
```
sub vcl_deliver {
    if (req.http.X-Cache) {
        set resp.http.X-Cache = req.http.X-Cache;
    }
}

```
## Verificación
```
curl -I http://phpvarnish.local/
```

# Ejercicio 3 – Excluir /admin y /login del caché
*Objetivo:* Pasar directamente al backend si la URL es sensible o privada.
```
sub vcl_recv {
    if (req.url ~ "^/(admin|login)") {
        return (pass);
    }

    return (hash);
}

```
## Verificación
```
curl -I http://phpvarnish.local/admin/index.php
curl -I http://phpvarnish.local/login/index.php
```


