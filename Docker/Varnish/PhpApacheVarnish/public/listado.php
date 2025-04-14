<?php
include 'header.php';
header('Surrogate-Control: content="ESI/1.0"');
?>

<!DOCTYPE html>
<html lang="en">
<?php include 'head.php'; ?>
<body>
<?php include 'body_header.php'; ?>
<main>
    <section>
        <table>
            <tr>
                <td>
                    <h1>Ejemplo de ESI</h1>
                </td>
            </tr>
            <tr>
                <td class="left">
                    <h2>Ejercicio 12 </h2>
                    <esi:include src="bloques/frase-del-dia.php" ></esi:include>

                    <h2>Ejercicio 13 </h2>
                    <esi:include src='bloques/bloque-no-cache.php'/>

                    <h2>Ejercicio 15 </h2>
                    <esi:include src="bloques/lang.php?lang=es" />


                </td>
                <td class="right">
                    <h2>Ejercicio 14</h2>
                    <esi:include src="bloques/publicidad.php"/>
                    <br/>
                    <esi:include src="bloques/alerta.php"/>
                </td>
            </tr>
        </table>


    </section>
</main>
<esi:include src="<?php echo BASE_URL; ?>/bloques/footer.php"/>
<?php include 'body_footer.php'; ?>


<script src="<?php echo BASE_URL; ?>js/script.js"></script>
</body>
</html>
