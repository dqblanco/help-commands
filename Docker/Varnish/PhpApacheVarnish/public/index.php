<?php
header("Cache-Control: public, max-age=30");

?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Título de la Página</title>
    <!-- Enlace a hojas de estilo -->
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<header>
    <h1>Título Principal</h1>
    <nav>
        <ul>
            <li><a href="#">Inicio</a></li>
            <li><a href="#">Acerca de</a></li>
            <li><a href="#">Contacto</a></li>
        </ul>
    </nav>
</header>

<main>
    <section>
        <h2>Subtítulo</h2>
        <p>Este es un párrafo de ejemplo para ilustrar una estructura básica de HTML.</p>
        <p><?php echo "Hola desde PHP! - " . date('H:i:s'); ?></p>
        <img src="img/varnish-bunny.png"  alt="varnish bunny"/>
    </section>
</main>

<footer>
    <p>&copy; 2025 Mi Sitio Web</p>
</footer>

<!-- Enlace a archivos JavaScript -->
<script src="js/script.js"></script>
</body>
</html>
