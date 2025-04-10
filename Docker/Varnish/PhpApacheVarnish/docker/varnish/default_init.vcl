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
    set beresp.ttl = 20s;
}
