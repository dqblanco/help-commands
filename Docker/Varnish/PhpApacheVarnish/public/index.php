<?php include 'header.php'; ?>
<!DOCTYPE html>
<html lang="en">
<?php include 'head.php'; ?>
<body>
<?php include 'body_header.php'; ?>
<main>
    <section>
        <h2>Subtítulo</h2>
        <p>Este es un párrafo de ejemplo para ilustrar una estructura básica de HTML.</p>
        <p><?php echo "Hola desde PHP! - " . date('H:i:s'); ?></p>
        <img src="img/varnish-bunny.png" alt="varnish bunny"/>
    </section>
</main>
<?php include 'body_footer.php'; ?>


<script src="<?php echo BASE_URL; ?>js/script.js"></script>
</body>
</html>
