<?php
header('Surrogate-Control: content="ESI/1.0"');
header(sprintf('xkey: item-%s', $_GET['id'] ));
?>
<h1>Mi id es: <?php echo  $_GET['id'] ?></h1>
<h2>Mi variable: <?php echo rand(1,100) ?></h2>
