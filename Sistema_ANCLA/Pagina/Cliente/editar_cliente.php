 <!-- incluimos la cabezera de la pagina-->
<?php

include "../menu/cabezera.php";
// se incluye la conexion para realizar las consultas sql

include "../../conexion.php";
//mientras el post no este vacio podra realizar la validacion 
if (!empty($_POST)) {
  $alert = "";
  // si no contiene los siguientes campos completos se aparecera un alerta 
  if (empty($_POST['nombre']) || empty($_POST['celular']) || empty($_POST['direccion'])) {
    $alert = '<div class="alert alert-warning" role="alert">
              Dato requerido 
            </div>';
    // de lo contrario le mostrara los siguientes campos completos
  } else {
    $idcliente = $_POST['id'];
    $ci = $_POST['ci'];
    $nombre = $_POST['nombre'];
    $celular = $_POST['celular'];
    $direccion = $_POST['direccion'];

    $result = 0;
    if (is_numeric($ci) and $ci != 0) {

      $query = mysqli_query($conexion, "SELECT * FROM cliente where (ci = '$ci' AND idcliente != $idcliente)");
      $result = mysqli_fetch_array($query);
      $resul = mysqli_num_rows($query);
    }
      // Si el campo de "cedula de identidad" tiene un valor mayor o igual a result, la cedula de identidad ya existe
    if ($resul >= 1) {
      $alert = '<div class="alert alert-warning role="alert">
              Cedula de identidad ya existente
            </div>';
    } else {
      if ($ci == '') {
        $ci = 0;
      }
      $sql_update = mysqli_query($conexion, "UPDATE cliente SET ci = $ci, nombre = '$nombre' , celular = '$celular', direccion = '$direccion' WHERE idcliente = $idcliente");

      if ($sql_update) {
         $alert = '<div class="alert alert-success" role="alert">
              Modificado
            </div>';
      } else {
       $alert = '<div class="alert alert-danger" role="alert">
              Error al modificar
            </div>';
      }
    }
  }
}
// Mostrar Datos

if (empty($_REQUEST['id'])) {
  header("Location: lista_clientes.php");
      mysql_close($conexion);
}
$idcliente = $_REQUEST['id'];
$sql = mysqli_query($conexion, "SELECT * FROM cliente WHERE idcliente = $idcliente");
$result_sql = mysqli_num_rows($sql);
if ($result_sql == 0) {
  header("Location: lista_clientes.php");
} else {
  while ($data = mysqli_fetch_array($sql)) {
    $idcliente = $data['idcliente'];
    $ci = $data['ci'];
    $nombre = $data['nombre'];
    $celular = $data['celular'];
    $direccion = $data['direccion'];
  }
}
?>
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
          <!--dentro de este formulario tendremos dos input de tipo hidden lo cual significa que va a estar oculto     -->
                <input type="hidden" name="id" value="<?php echo $idcliente; ?>">
                <div class="form-group">
                  <label for="ci">Dni</label>
                  <input type="number" placeholder="Ingrese dni" name="ci" id="ci" class="form-control" value="<?php echo $ci; ?>">
                </div>
                <div class="form-group">
                  <label for="nombre">Nombre</label>
                  <input type="text" placeholder="Ingrese Nombre" name="nombre" class="form-control" id="nombre" value="<?php echo $nombre; ?>">
                </div>
                <div class="form-group">
                  <label for="celular">Teléfono</label>
                  <input type="number" placeholder="Ingrese Teléfono" name="celular" class="form-control" id="celular" value="<?php echo $celular; ?>">
                </div>
                <div class="form-group">
                  <label for="direccion">Dirección</label>
                  <input type="text" placeholder="Ingrese Direccion" name="direccion" class="form-control" id="direccion" value="<?php echo $direccion; ?>">
                </div>
                <button type="submit" class="btn btn-primary"><i class="fas fa-user-edit"></i> Editar Cliente</button>
                <a href="lista_clientes.php" class="btn btn-primary">Lista de Clientes</a>
                
      </form>
    </div>
<?php 
include "../menu/footer.php";

?>

