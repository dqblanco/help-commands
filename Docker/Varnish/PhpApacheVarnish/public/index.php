<?php
header("Cache-Control: public, max-age=60");
echo "Hola desde PHP-FPM! - " . date('H:i:s');
