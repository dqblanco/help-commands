import xkey;

sub app_tags_xkey_recv {
    if (req.method == "PURGEKEYS") {
        if (!client.ip ~ invalidators) {
            return (synth(405, "Not allowed"));
        }

        if (!req.http.xkey-purge && !req.http.xkey-softpurge) {
            return (synth(400, "Neither header XKey-Purge or XKey-SoftPurge set"));
        }


        set req.http.n-gone = 0;
        set req.http.n-softgone = 0;
        if (req.http.xkey-purge) {
            set req.http.n-gone = xkey.purge(req.http.xkey-purge);
        }

        if (req.http.xkey-softpurge) {
            set req.http.n-softgone = xkey.softpurge(req.http.xkey-softpurge);
        }

        return (synth(200, "Purged "+req.http.n-gone+" objects, expired "+req.http.n-softgone+" objects"));
    }
}

