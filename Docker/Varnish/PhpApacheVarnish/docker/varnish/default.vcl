vcl 4.1;

#Conexión al backend
backend default {
    .host = "apache";
    .port = "80";
}

sub vcl_recv {


    return (hash);
}

#beresp.ttl = Tiempo en que un contenido puede permanecer en caché
sub vcl_backend_response {

    set beresp.ttl = 2s;
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

    if (beresp.http.Surrogate-Control ~ "ESI/1.0") {
        set beresp.do_esi = true;
    }
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