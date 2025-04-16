<?php
include 'header.php';
header('Surrogate-Control: content="ESI/1.0"');
header('xkey: detalle-inmueble item-'.$_GET['id']);
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
                    <h1>Detalle <?php echo $_GET['id']?> </h1>
                </td>
            </tr>
            <tr>
                <td class="left">
                    <h2>Mi variable: <?php echo rand(1,100) ?></h2>
                </td>
                <td class="right">

                </td>
            </tr>
        </table>


    </section>
</main>
<?php include 'body_footer.php'; ?>


<script src="js/script.js"></script>
</body>
</html>
