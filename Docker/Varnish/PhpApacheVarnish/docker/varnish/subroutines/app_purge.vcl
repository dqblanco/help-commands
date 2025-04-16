sub app_purge_recv {
    if (req.method == "PURGE") {
        if (!client.ip ~ invalidators) {
            return (synth(401, "Invalid IPs"));
        }

        if (req.http.x-purge-token != "PURGE_NOW") {
             return(synth(405, "Header Not Found"));
        }
        return (purge);

    }
}
