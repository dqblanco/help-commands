# Ejercicios Uso Varnish Nivel Básico

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Ejemplos y ejercicio curso Varnish Nivel Básico

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


# Ejercicio 4 – Modificar el TTL solo para js y css
*Objetivo:* Servir css y js desde la caché durante 5 segundo y comprimirlos

```
sub vcl_backend_response {
     if (bereq.url ~ "\.(css|js)$") {
            set beresp.do_gzip = true; // Activa compresión gzip si está disponible
            set beresp.http.Cache-Control = "public, max-age=6";
            set beresp.ttl = 6s;
     }
}
```
## Verificación

```
curl -I http://phpvarnish.local/js/script.js
```

#  Ejercicio 5 - Manejo de errores HTTP: cachear 500, ignorar 404
```
sub vcl_backend_response{
    # Manejar errores 500 con TTL de 120s
    if (beresp.status >= 500) {
        set beresp.http.Cache-Control = "public, max-age=120";
        set beresp.ttl = 120s;
        return (deliver);
    }

    # No almacenar en caché errores 404
    if (beresp.status == 404) {
        set beresp.http.Cache-Control = "public, max-age=0";
        set beresp.ttl = 0s;
        return (deliver);
    }
}

```
## Verificación

```
curl -I http://phpvarnish.local/error500.php
curl -I http://phpvarnish.local/error404.php
```

# Ejercicio 6 – Simular backend caído con grace
**En vcl_backend_response:**
```
sub vcl_backend_response {
    set beresp.grace = 2m;  
}
```
Pasos:
- Accedé a una página para que se almacene en caché.
- Apagá el contenedor de Apache: `docker stop apache`
  Volvé a hacer la solicitud:

Varnish debería servir el contenido igual (en modo grace).


# Ejercicio 7 Header personalizado
Ideal para: debugging, tracking, etc.
```
sub vcl_recv {
    set req.http.X-Received = "from vcl_recv";
    return (hash);
}

sub vcl_deliver {
   
    if (req.http.X-Received) {
        set resp.http.X-Received = req.http.X-Received;
    }
}
```
## Verificación

```
curl -I http://phpvarnish.local/
```
# Ejercicio 8 – Controlar el caché por User-Agent
**Objetivo:** Evitar que ciertos User-Agents (como bots o crawlers) reciban contenido desde la caché.

```
sub vcl_recv {
    if (req.http.User-Agent ~ "(?i)bot|crawl|spider") {
        return (pass);
    }
    return (hash);
}
```
## Verificación
```
curl -I -A "Googlebot" http://phpvarnish.local/
```
```
curl -I -A "Mozilla/5.0" http://phpvarnish.local/
```

# Ejercicio 9 – Evitar cacheo de peticiones con cookie de sesión
**Objetivo:** Evitar cachear contenido personalizado para usuarios logueados.

```
sub vcl_recv {
    if (req.http.Cookie ~ "PHPSESSID") {
        return (pass);
    }
    return (hash);
}

```

## Verificación
```
curl -I --cookie "PHPSESSID=abc123" http://phpvarnish.local/
```
```
curl -I http://phpvarnish.local/
```

# Ejercicio 11 – Añadir cabecera con la IP del cliente
**Objetivo:** Agregar un header personalizado que indique la IP del cliente que hizo la solicitud, útil para debugging o trazabilidad.
```
sub vcl_deliver {
    set resp.http.X-Client-IP = client.ip;
}
```
## Verificación
```
curl -I http://phpvarnish.local/
```


# Ejercicio 12 – Activar uso de ESI

Crear un nuevo archivo `bloques/frase-del-día.php`
```
<?php
echo "La frase de hoy es: " . date('H:i:s');
```
Incluir en el index el Bloque ESI
```
<esi:include src="bloques/frase-del-día.php" ></esi:include>
```
Agregar header Surrogate-Control 
```
header('Surrogate-Control: content="ESI/1.0"');
```

Forzar que varnish interprete la ESI
```
sub vcl_backend_response {
  if (beresp.http.Surrogate-Control ~ "ESI/1.0") {
        set beresp.do_esi = true;
    }
}
```

# Ejercicio 13 – Evitar cachear el fragmento
**Objetivo:** Mostrar cómo ESI puede cargar un fragmento sin cachear.

Crear un nuevo archivo `bloques/bloque-no-cache.php`
```
<?php
header("Cache-Control: no-store");
echo "Usuario: invitado-".rand(100,999);
```
Incluir en el index el Bloque ESI
```
<esi:include src='bloques/bloque-no-cache.php' />
```


# Ejercicio 14 – TTL diferente por fragmento
**Objetivo:** Cachear cada fragmento con TTL personalizado.

Crear un nuevo archivo `bloques/publicidad.php`
```
<?php
header("Cache-Control: max-age=20");
echo "Publicidad del minuto: Oferta #".rand(1,100);
```
Crear un nuevo archivo `bloques/alerta.php`
```
<?php
header("Cache-Control: max-age=5");
echo "Alerta nivel ".rand(1,9);
```

# Ejercicio 15 – Contenido multilenguaje dinámico con ESI
**Objetivo:** Mostrar contenido de idioma diferente por fragmento ESI.

Crear un nuevo archivo `bloques/lang.php`
```
<?php
$idioma = $_GET['lang'] ?? 'es';
$frases = ['es' => 'Bienvenido', 'en' => 'Welcome', 'fr' => 'Bienvenue'];
echo $frases[$idioma];
```
Incluir en el index el Bloque ESI
```
<esi:include src="/bloques/lang.php?lang=en" />'
```

