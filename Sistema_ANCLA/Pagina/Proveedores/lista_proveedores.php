<!--incluimos la cabecera de la pagina-->
<?php 

include "../menu/cabezera.php";?>
<div class="content-wrapper">
  <section class="content">
    <!--este es el contenido principal-->
    <div class="row" id="contenido_principal">
  <div class="col-md-12">
    <!--este es la parte de la cabecera que mostrara un titulo principal-->
    <div class="box box-warning box-solid">
     <div class="box-header with-border">
     <h3 class="box-title">Bienvenido a la Lista de Proveedores</h3>
     </div>
     </div>
     <!--este es la parte del cuerpo del contenido de la pagina-->
<div class="box-body">  
<!--creacion de la tabla-->  
<table  id="table" class="table  table-bordered .table-striped thead-dark" style="width:100%">
  <thead>    <!--se declara los campos de la tabla-->
  <tr>
  <th>ID</th>
  <th>RUC</th>
  <th>PROVEEDOR</th>
  <th>TELEFONO</th>
  <th>DIRECCION</th>
  <th>ACCIONES</th>
  </tr>
  </thead>
  <tbody>
  <?php
  //incluimos la conexion para poder realizar las consultas sql
  include "../../conexion.php";
  /*se realiza la consulta sql,en donde seleccionamos todos los campos de la tabla ticket, */
   /*se realiza la consulta sql,en donde seleccionamos todos los campos   de proveedor*/
   $query = mysqli_query($conexion, "SELECT * FROM proveedor");
    //guardo la consulta en la variable $result
    $result = mysqli_num_rows($query);
    //condicionamos si la variable $result es mayor a 0,ocurrira lo siguiente
    /*almacenamos la consulta realiza,en la variable $data por medio de la funcion mysqli_fetch_array*/
  //guardo la consulta en la variable $result
  if ($result > 0) 
  {
  //condicionamos si la variable $cli es mayor a 0,ocurrira lo siguiente
    /*almacenamos la consulta realiza,en la variable $data por medio de la funcion mysqli_fetch_array*/
  while ($data=mysqli_fetch_array($query)) 
  {
  ?>
  <!--mostramos en la tabla los datos-->
  <tr>
   <td><?php echo $data['codproveedor']; ?></td>
    <td><?php echo $data['contacto']; ?></td>
    <td><?php echo $data['proveedor']; ?></td>
    <td><?php echo $data['celular']; ?></td>
    <td><?php echo $data['direccion']; ?></td>
  <td>
    <!--si crea el boton editar y eliminar, donde guardara o eliminara en la base de datoss-->
  <a href="editar_proveedores.php?id=<?php echo $data['codproveedor']; ?>" class="btn btn-success"><i class='fas fa-edit'></i> Editar</a>
  <form action="eliminar_proveedor.php?id=<?php echo $data['codproveedor']; ?>" method="post" class="confirmar d-inline">
    <button class="btn btn-danger" type="submit"><i class='fas fa-trash-alt'></i> </button>
  </form>
    
  </div>
  
   </td>
  </tr>
  <?php }
  } ?>
</tbody>
</table>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</section>
<!--se llama al pie de la pagina-->
<?php 
include "../menu/footer.php";

?>

