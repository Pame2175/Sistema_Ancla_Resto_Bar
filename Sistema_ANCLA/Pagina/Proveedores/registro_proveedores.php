<?php 
include "../menu/cabezera.php";
include "../../conexion.php";

if (!empty($_POST)) {
    $alert = "";
    if (empty($_POST['proveedor']) || empty($_POST['contacto']) || empty($_POST['celular']) || empty($_POST['direccion'])) {
        $alert = '<div class="alert alert-danger" role="alert">
                        Todo los campos son obligatorios
                    </div>';
    } else {
        $proveedor = $_POST['proveedor'];
        $contacto = $_POST['contacto'];
        $telefono = $_POST['celular'];
        $Direccion = $_POST['direccion'];
        $usuario_id = $_SESSION['idUser'];
        $query = mysqli_query($conexion, "SELECT * FROM proveedor where contacto = '$contacto'");
        $result = mysqli_fetch_array($query);

        if ($result > 0) {
            $alert = '<div class="alert alert-danger" role="alert">
                        El Ruc ya esta registrado
                    </div>';
        }else{
        

        $query_insert = mysqli_query($conexion, "INSERT INTO proveedor(proveedor,contacto,celular,direccion,usuario_id) values ('$proveedor', '$contacto', '$telefono', '$Direccion','$usuario_id')");
        if ($query_insert) {
            $alert = '<div class="alert alert-primary" role="alert">
                        Proveedor Registrado
                    </div>';
        } else {
            $alert = '<div class="alert alert-danger" role="alert">
                       Error al registrar proveedor
                    </div>';
        }
        }
    }
}
mysqli_close($conexion);
?>


        <div class="content-wrapper">
  <section class="content">
    <div class="row" id="contenido_principal">
    <div class="col-md-12">
    <div class="box box-warning box-solid">
     <div class="box-header with-border">
     <h3 class="box-title">Bienvenido al Portal de Proveedores</h3>
     </div>
     </div>
<div class="box-body">
            <form action="" method="post" autocomplete="off">
                 <?php echo isset($alert) ? $alert : ''; ?>
                    <div class="form-group">
                        <label for="nombre">Nombre</label>
                        <input type="text" placeholder="Ingrese nombre" name="proveedor" id="proveedors" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="contacto">Ruc</label>
                        <input type="text" placeholder="Ingrese nombre del contacto" name="contacto" id="contacto" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="telefono">Teléfono</label>
                        <input type="number" placeholder="Ingrese teléfono" name="celular" id="telefono" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="direccion">Dirección</label>
                        <input type="text" placeholder="Ingrese Direccion" name="direccion" id="direcion" class="form-control">
                    </div>
                    <input type="submit" value="Guardar Proveedor" class="btn btn-primary">
                    <a href="lista_proveedores.php" class="btn btn-danger">Regresar</a>
      
            </form>
        </div>
    </div>
</div>
</div>
</div>
</section>

  <?php

include "../menu/footer.php";  ?>





  
