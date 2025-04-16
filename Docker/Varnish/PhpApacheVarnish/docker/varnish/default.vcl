vcl 4.1;
import std;
include "subroutines/app_purge.vcl";

acl invalidators {
    "localhost";             // loopback
    "varnish";      // otro contenedor permitido
    "workspace";
}

#Conexión al backend
backend default {
    .host = "apache";
    .port = "80";
}

sub vcl_recv {
      call app_purge_recv;

      if (req.url ~ "^/(admin|login)") {
            std.log("REMAX: hola");
             return (pass);
         }

          if (req.http.User-Agent ~ "(?i)bot|crawl|spider") {
             return (pass);
          }

           if (req.http.Cookie ~ "PHPSESSID") {
                  return (pass);
              }
        set req.http.x-esi-level = req.esi_level;
        set req.http.X-Received = "from vcl_recv";



    return (hash);
}

#beresp.ttl = Tiempo en que un contenido puede permanecer en caché
sub vcl_backend_response {

    set beresp.ttl = 30s;
    set beresp.http.Cache-Control = "public, max-age=10";

     if (bereq.url ~ "\.(css|js)$") {
        set beresp.do_gzip = true; // Activa compresión gzip si está disponible
        set beresp.http.Cache-Control = "public, max-age=6";
        set beresp.ttl = 6s;
     }

    if (bereq.url ~ "\.(png|jpg|jpeg|gif|webp)$") {
            set beresp.ttl = 30s;
            #set beresp.http.Cache-Control = "public, max-age=30";
            #No se cachea en el browser
            set beresp.http.Cache-Control = "no-store";
    }

    if (bereq.url ~ "/bloques/publicidad.php") {
        set beresp.http.Cache-Control = "public, max-age=60";
        set beresp.ttl = 60s;
    }

    if (bereq.url ~ "/bloques/alerta.php") {
        set beresp.http.Cache-Control = "public, max-age=5";
        set beresp.ttl = 5s;
    }

     if (bereq.url ~ "/bloques/item.php") {
            set beresp.http.Cache-Control = "public, max-age=20";
            set beresp.ttl = 20s;
        }

    if (beresp.http.Surrogate-Control ~ "ESI/1.0") {
        set beresp.do_esi = true;
    }

     set beresp.http.X-Url = bereq.url;
     set beresp.http.X-Host = bereq.http.host;
    #set beresp.do_esi = true;

}

sub vcl_hit {
    set req.http.X-Cache = "HIT";
    return (deliver);
}

sub vcl_miss {
    set req.http.X-Cache = "MISS";
    return (fetch);
}

sub vcl_deliver {
    if (req.http.X-Cache) {
        if(obj.hits > 0){
            set resp.http.X-Cache-Hits = obj.hits;
        }
        set resp.http.X-Cache = req.http.X-Cache;
    }

    if (req.http.X-Received) {
        set resp.http.X-Received = req.http.X-Received;
    }

    set resp.http.X-Client-IP = client.ip;
}