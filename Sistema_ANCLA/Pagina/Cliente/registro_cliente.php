<?php 
include "../menu/cabezera.php";
include "../../conexion.php";

if (!empty($_POST)) {
    $alert = "";
    if (empty($_POST['nombre']) || empty($_POST['celular']) || empty($_POST['direccion'])) {
        $alert = '<div class="alert alert-danger" role="alert">
                                    Todo los campos son obligatorio
                                </div>';
    } else {
        $ci = $_POST['ci'];
        $nombre = $_POST['nombre'];
        $celular = $_POST['celular'];
        $direccion = $_POST['direccion'];
        $usuario_id = $_SESSION['idUser'];

        $result = 0;
        if (is_numeric($ci) and $ci != 0) {
            $query = mysqli_query($conexion, "SELECT * FROM cliente where ci = '$ci'");
            $result = mysqli_fetch_array($query);
        }
        if ($result > 0) {
            $alert = '<div class="alert alert-danger" role="alert">
                                    Dicha cedula de idenidad ya esta registrado
                                </div>';
        } else {
            $query_insert = mysqli_query($conexion, "INSERT INTO cliente(ci,nombre,direccion, celular,usuario_id) values ('$ci', '$nombre','$direccion',  '$celular', '$usuario_id')");
            if ($query_insert) {
                $alert = '<div class="alert alert-primary" role="alert">
                                    Cliente Registrado
                                </div>';
            } else {
                $alert = '<div class="alert alert-danger" role="alert">
                                    Error al Guardar
                            </div>';
            }
        }
    }
    mysqli_close($conexion);
}
?>


        <div class="content-wrapper">
  <section class="content">
    <div class="row" id="contenido_principal">
    <div class="col-md-12">
    <div class="box box-warning box-solid">
     <div class="box-header with-border">
     <h3 class="box-title">Bienvenido al Portal de Cliente</h3>
     </div>
     </div>
<div class="box-body">
            <form action="" method="post" autocomplete="off">
                <?php echo isset($alert) ? $alert : ''; ?>
                <div class="form-group">
                    <label for="ci">Cedula de Identidad</label>
                    <input type="number" placeholder="Ingrese cedula de Identidad" name="ci" id="ci" class="form-control">
                </div>
                <div class="form-group">
                    <label for="nombre">Nombre</label>
                    <input type="text" placeholder="Ingrese Nombre" name="nombre" id="nombre" class="form-control">
                </div>
                <div class="form-group">
                    <label for="telefono">Teléfono</label>
                    <input type="number" placeholder="Ingrese Teléfono" name="celular" id="celular" class="form-control">
                </div>
                <div class="form-group">
                    <label for="direccion">Dirección</label>
                    <input type="text" placeholder="Ingrese Dirección" name="direccion" id="direccion" class="form-control">
                </div>
                <input type="submit" value="Guardar Cliente" class="btn btn-primary">
                 <a href="lista_clientes.php" class="btn btn-danger">Regresar</a>
      
            </form>
        </div>
    </div>
</div>
</div>
</div>
</section>

  <?php

include "../menu/footer.php";  ?>





  
