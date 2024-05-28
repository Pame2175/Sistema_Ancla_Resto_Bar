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
     <h3 class="box-title">Bienvenido a la Lista de Venta</h3>
     </div>
     </div>
     <!--este es la parte del cuerpo del contenido de la pagina-->
<div class="box-body">  
<!--creacion de la tabla-->  
<table  id="table" class="table  table-bordered .table-striped thead-dark" style="width:100%">
  <thead>    <!--se declara los campos de la tabla-->
  <tr>
  <td>NOTICKET</td>
  <td>FECHA</td>
  <td>TOTAL</td>
  <td>ACCIONES</td>
  </tr>
  </thead>
  <tbody>
  <?php
  //incluimos la conexion para poder realizar las consultas sql
  include "../../conexion.php";
  /*se realiza la consulta sql,en donde seleccionamos todos los campos de la tabla ticket, */
  $query = mysqli_query($conexion, "SELECT noticket, fecha,codcliente, totalticket, estado FROM ticket ORDER BY noticket DESC");
  //cerramos la conexion
  mysqli_close($conexion);
  //guardo la consulta en la variable $cli
  $cli= mysqli_num_rows($query);
  //condicionamos si la variable $cli es mayor a 0,ocurrira lo siguiente
  if ($cli>0) 
  {
    /*almacenamos la consulta realiza,en la variable $data por medio de la funcion mysqli_fetch_array*/
  while ($dato=mysqli_fetch_array($query)) 
  {
  ?>
  <!--mostramos en la tabla los datos-->
  <tr>
  <td><?php echo $dato['noticket']; ?></td>
  <td><?php echo $dato['fecha']; ?></td>
  <td><?php echo $dato['totalticket']; ?></td>
  <td>
    <!--si crea el boton ver,;en la cual se podra observar la factura generada-->
      <button type="button" class="btn btn-primary vista_ticket" cl="<?php echo $dato['codcliente']; ?>" f="<?php echo $dato['noticket']; ?>">Ver</button>
    
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

