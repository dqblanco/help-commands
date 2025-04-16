<?php
$ch = curl_init('http://varnish/');
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PURGEKEYS');
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Host: phpvarnish.local',
    'xkey-purge: item-'.$_GET['id'],
]);
curl_exec($ch);
curl_close($ch);
