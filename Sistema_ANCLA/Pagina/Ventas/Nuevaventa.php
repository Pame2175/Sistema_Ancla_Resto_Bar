
<?php
//si incluye la cabezera de la pagina
  include_once "../menu/cabezera.php";
  
 ?>
 <!--Contiene el encabezado y el contenido de la página.-->
 <div class="content-wrapper">
    <section class="content">
    <h3 class="box-title">Bienvenido al Portal de Ventas</h3>   
    <!--este es el cuerpo del contenido-->
    <div class="box-body">
    <?php
    //incluimos la conexion
    include "../../conexion.php";
    //se realiza una consulta sql,seleccionando toda la tabla cliente
    $query = mysqli_query($conexion, "SELECT * FROM cliente");
    //cerramos la conexion
    mysqli_close($conexion);
    //guardamos la consulta en la variable $resultado
    $resultado = mysqli_num_rows($query);
    //realizamos la condicional,preguntando si es mayor a 0
    if ($resultado>0)
    {
        /*si es mayor a 0,siginifica que trae datos,lo almacenamos en la variable $data por medio de mysqli_fetch_array*/
        $data = mysqli_fetch_array($query);
    }
    ?>
    <!--Creamos un titulo datos del cliete-->
    <h4 class="text-center">Datos del Cliente</h4>
    <div class="card">
    <div class="card-body">
    <form method="post" name="form_new_cliente_venta" id="form_new_cliente_venta">
    <!--dentro de este formulario tendremos dos input de tipo hidden lo cual significa que va a estar oculto y tendra un valor addcliente al enviar los datos y segundo un valor vacio y va a ser requerido             -->
    <input type="hidden" name="action" value="addCliente">
    <input type="hidden" id="idcliente" value="" name="idcliente" required>
    <div class="row">
    <div class="col-lg-4">
    <div class="form-group">
    <label>CI</label>
    <input type="number" name="ci_cliente" id="ci_cliente" class="form-control">
    </div>
    </div>
    <div class="col-lg-4">
    <div class="form-group">
    <!-- aca se introducira el nombre del cliente ,la cual sera requerido y aparecera desactivado-->
    <label>Nombre</label>
    <input type="text" name="nom_cliente" id="nom_cliente" class="form-control" disabled required>
    </div>
    </div>
    <div class="col-lg-4">
    <div class="form-group">
    <label>Celular</label>
    <input type="text" name="cel_cliente" id="cel_cliente" class="form-control" disabled required>
    </div>
    </div>
    <div class="col-lg-4">
    <div class="form-group">
    <label>Dirreción</label>
    <input type="text" name="dir_cliente" id="dir_cliente" class="form-control" disabled required>
    </div>
    </div>
    </div>
    </form>
    </div>
    </div>
    <h4 class="text-center">Datos Venta</h4>
    <div class="row">
    <div class="col-lg-6">
    <div class="form-group">
    <label><i class="fas fa-user"></i> VENDEDOR</label>
    <p>ANCLA</p>
    <p style="font-size: 16px; text-transform: uppercase; color: blue;"></p>
    </div>
    </div>
    <div class="col-lg-6">
    <label>Acciones</label>
    <div id="acciones_venta" class="form-group">
    <a href="#" class="btn btn-primary" id="btn_facturar_venta"><i class="fas fa-save"></i> Generar Venta</a>
    </div>
    </div>
    </div>
    <table class="table table-hover">
    <thead class="thead-dark">
    <tr>
    <th width="100px">Código</th>
    <th>Des.</th>
    <th>Stock</th>
    <th width="8px">Cantidad</th>
    <th class="textright">Precio</th>
    <th class="textright">Precio Total</th>
    <th>Acciones</th>
    </tr>
    <tr>
    <td><input type="number" name="txt_cod_producto" id="txt_cod_producto"></td>
    <td id="txt_descripcion">-</td>
    <td id="txt_existencia">-</td>
    <td><input type="text" name="txt_cant_producto" id="txt_cant_producto"value="0" min="1" disabled></td>
    <td id="txt_precio" class="textright">0.00</td>
    <td id="txt_precio_total" class="txtright">0.00</td>
    <td><a href="#" id="add_product_venta" class="btn btn-dark" style="display:none;">Agregar</a></td>
    </tr>
    <tr>
    <th>Código</th>
    <th colspan="2">Descripción</th>
    <th>Cantidad</th>
    <th class="textright">Precio</th>
    <th class="textright">Precio Total</th>
    <th>Acciones</th>
    </tr>
    </thead>
    <tbody id="detalle_venta">
    <!-- Contenido cargado por medio de ajax -->

    </tbody>

    <tfoot id="detalle_totales">
    <!-- Contenido cargado por medio de  ajax -->
    </tfoot>
    </table>
</div>
</section>
</div>
<!--incluimos el pie de la pagina-->
<?php
  include "../menu/footer.php";
  ?>
  