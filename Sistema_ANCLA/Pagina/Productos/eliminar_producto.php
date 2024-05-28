<?php
if (!empty($_GET['id'])) {
    require("../../conexion.php");
    $id = $_GET['id'];
    $query_delete = mysqli_query($conexion, "DELETE FROM producto WHERE codproducto = $id");
    mysqli_close($conexion);
    header("location: productos.php");
}
?>