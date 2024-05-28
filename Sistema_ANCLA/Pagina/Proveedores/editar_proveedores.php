<?php
include "../../conexion.php";
if (!empty($_POST)) {
  $alert = "";
  if (empty($_POST['proveedor']) || empty($_POST['contacto']) || empty($_POST['celular']) || empty($_POST['direccion'])) {
   $alert = '<div class="alert alert-warning" role="alert">
              Datos requerido 
            </div>';
  } else {
    $idproveedor = $_GET['id'];
    $proveedor = $_POST['proveedor'];
    $contacto = $_POST['contacto'];
    $celular = $_POST['celular'];
    $direccion = $_POST['direccion'];

    $sql_update = mysqli_query($conexion, "UPDATE proveedor SET proveedor = '$proveedor', contacto = '$contacto' , celular = $celular, direccion = '$direccion' WHERE codproveedor = $idproveedor");

    if ($sql_update) {
     $alert = '<div class="alert alert-success role="alert">
              Actualizado
            </div>';
    } else {
      $alert = '<div class="alert alert-danger role="alert">
             Error al actualizar
            </div>';
    }
  }
}
// Mostrar Datos

if (empty($_REQUEST['id'])) {
  header("Location: lista_proveedores.php");
  mysqli_close($conexion);
}
$idproveedor = $_REQUEST['id'];
$sql = mysqli_query($conexion, "SELECT * FROM proveedor WHERE codproveedor = $idproveedor");
mysqli_close($conexion);
$result_sql = mysqli_num_rows($sql);
if ($result_sql == 0) {
  header("Location: lista_proveedores.php");
} else {
  while ($data = mysqli_fetch_array($sql)) {
    $idproveedor = $data['codproveedor'];
    $proveedor = $data['proveedor'];
    $contacto = $data['contacto'];
    $celular = $data['celular'];
    $direccion = $data['direccion'];
  }
}
include "../menu/cabezera.php";

?>
<!-- Begin Page Content -->
<style type="text/css">
  
.abs-center {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 80vh;
}

.form {
  width: 800px;
}


</style>

    <div class="abs-center">
      
      <form class="border p-3 form" action="" method="post">
        <?php echo isset($alert) ? $alert : ''; ?>
        <input type="hidden" name="id" value="<?php echo $idproveedor; ?>">
        <div class="form-group">
          <label for="proveedor">Proveedor</label>
          <input type="text" placeholder="Ingrese proveedor" name="proveedor" class="form-control" id="proveedor" value="<?php echo $proveedor; ?>">
        </div>
        <div class="form-group">
          <label for="nombre">Contacto</label>
          <input type="text" placeholder="Ingrese contacto" name="contacto" class="form-control" id="contacto" value="<?php echo $contacto; ?>">
        </div>
        <div class="form-group">
          <label for="celular">Teléfono</label>
          <input type="number" placeholder="Ingrese Teléfono" name="celular" class="form-control" id="celular" value="<?php echo $celular; ?>">
        </div>
        <div class="form-group">      
          <label for="direccion">Dirección</label>
          <input type="text" placeholder="Ingrese Direccion" name="direccion" class="form-control" id="direccion" value="<?php echo $direccion; ?>">
      </div>

        <input type="submit" value="Editar Proveedor" class="btn btn-primary">
        <a href="lista_proveedores.php" class="btn btn-primary">Lista de Clientes</a>
      </form>
    
<!-- /.container-fluid -->

</div>
<!-- End of Main Content -->
<?php include "../menu/footer.php";
 ?>