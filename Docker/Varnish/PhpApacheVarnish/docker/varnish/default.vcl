vcl 4.1;

#Conexión al backend
backend default {
    .host = "apache";
    .port = "80";
}

sub vcl_recv {
     if (req.url ~ "^/(admin|login)") {
        return (pass);
    }
    return (hash);
}

#beresp.ttl = Tiempo en que un contenido puede permanecer en caché
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
}