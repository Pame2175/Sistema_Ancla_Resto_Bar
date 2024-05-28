
<?php
include("../../conexion.php");
session_start();
// Buscar Cliente
/*
esta condicion dice, que lo que viene en el metodo POST
en la variable action es igual a searchCliente entonces se ejecuta la condicion que pongamos abajo
*/
if (!empty($_POST)) 
{
if ($_POST['action']=='BuscarCliente') 
{
  // evaluamos si la variable cliente no venga vacio,sino viene vacio se ejecuta los siguiente codigos
  if (!empty($_POST['cliente'])) 
  {
    //guardamos en una variable $cl, lo que se ha enviado en el metodo post
    $ci = $_POST['cliente'];

   $query = mysqli_query($conexion, "SELECT * FROM cliente WHERE ci LIKE '$ci'");
    mysqli_close($conexion);
    $result = mysqli_num_rows($query);
    $data = '';
    if ($result > 0) 
    {
      //Obtiene una fila de resultado como un array asociativo
      $data = mysqli_fetch_assoc($query);
    }else 
    {
      $data = 0;
    }
    echo json_encode($data,JSON_UNESCAPED_UNICODE);
  }
  //si viene vacio saldra solamente de la condicion
  exit;
}

  // Extraer datos del producto
//Verificamos si action trae el valor que tiene en la funcion 
  if ($_POST['action']=='infoProducto') 
  {
    $data = "";
    //guardamos en la variable $producto_id lo que recibimos del ajax
    $producto_id = $_POST['producto'];
    /*Mediante mysqli_query ,realizamos una consulta 
    a la bd para que traiga los valores de productos si codproducto=$producto_id*/
    $query = mysqli_query($conexion, "SELECT codproducto, descripcion, precio, existencia FROM producto WHERE codproducto=$producto_id");
    /*en la variable $result guardamos la lista de datos 
    que recibimos de $query*/
    $result = mysqli_num_rows($query);
    if ($result > 0) 
    {/*almacenamos en un array lo que extraemos del $query */
      $data = mysqli_fetch_assoc($query);
      //retornamos el array data por medio del formate json_encode 
      echo json_encode($data,JSON_UNESCAPED_UNICODE);
      exit;
    }else 
    {
      $data = 0;
    }
  }

// agregar producto a detalle temporal
/*
Verificamos si action trae el valor que tiene en la funcion
*/
if ($_POST['action']=='AgregarProductoDetalle') 
{
  /*Verificamos si el campo  producto o el campo cantidad viene vacio ,
  mostrara un mensaje de error*/
       if (empty($_POST['producto']) || empty($_POST['cantidad']))
      {
        echo 'error';
      }else 
      /*Sino vino vacio los campos se ejecuta,es decir que trajo datos,guardamos esos datos en la variable $codproducto y $cantidad*/
      {
        $codproducto = $_POST['producto'];
        $cantidad = $_POST['cantidad'];
        $id_usuario=md5($_SESSION['idUser']);
        //aca mediante el query obtenemos el valor de iva de la tabla configuracion
      $query_iva = mysqli_query($conexion, "SELECT iva FROM configuracion");
      //guardamos en la variable  $result_iva la cantidad de fila que va a devolver
        $result_iva = mysqli_num_rows($query_iva);
        /*
        almacenamos en la variable  $query_detalle_temp lo que nos
        devolvera el procedimiento almacenado;mediante CAll ejecutamos el procedimiento almacenado
        */
        /* Pasamos como parametro el $codproducto y la $cantidad 
        que recibimos desde  el ajax, */
        $query_detalle_temp = mysqli_query($conexion, "CALL Agregar_detalle_temporal ($codproducto,$cantidad,'$id_usuario')");
        //guardamos en la variable $result la cantidad de fila que vamos a recibir del procedimiento almacenado
        $result = mysqli_num_rows($query_detalle_temp);
        $detalleTabla = '';
        $sub_total = 0;
        $iva = 0;
        $total = 0;
        $arrayData = array();
        //evaluamos se la variable $result es mayor a 0
        if ($result>0)
        {
          //si mayor a 0 significa que tiene datos
        if ($result_iva > 0) {
          /*almacenamos en un array lo que extraemos del $query_iva */
        $info_iva = mysqli_fetch_assoc($query_iva);
        $iva = $info_iva['iva'];
      }
      /*en la variable data estamos almacenando todo el query que nos esta devolviendo en este caso el procedimiento almacenado, por medio de mysqli_fetch_assoc */
      while ($data = mysqli_fetch_assoc($query_detalle_temp)) {
        //calculamos el preciototal efectuando la operacion de multiplicacion
      $precioTotal = round($data['cantidad'] * $data['precio_venta'], 2);
      //aca calcula el subtotal de la venta
      $sub_total = round($sub_total + $precioTotal, 2);
      //calculamo el total de la venta
      $total = round($total + $precioTotal, 2);
        //creamos una tabla en ajax en donde mostramos los datos
        $detalleTabla .='<tr>
            <td>'.$data['codproducto'].'</td>
            <td colspan="2">'.$data['descripcion'].'</td>
            <td class="textcenter">'.$data['cantidad'].'</td>
            <td class="textright">'.$data['precio_venta'].'</td>
            <td class="textright">'.$precioTotal.'</td>
            <td>
                <a href="#" class="btn btn-danger" onclick="event.preventDefault(); Eliminar_producto_detalle('.$data['correlativo'].');"><i class="fas fa-trash-alt"></i> Eliminar</a>
            </td>
        </tr>';
    }
    //calculamos el impuesto
    $impuesto = round($sub_total / $iva, 2);
    //calculamos el total sin iva
    $tl_sniva = round($sub_total - $impuesto, 2);
    $total = round($tl_sniva + $impuesto, 2);
    $detalleTotales ='<tr>
        <td colspan="5" class="textright">Sub_Total S/.</td>
        <td class="textright">'.$impuesto.'</td>
    </tr>
    <tr>
        <td colspan="5" class="textright">Igv ('.$iva.'%)</td>
        <td class="textright">'. $tl_sniva.'</td>
    </tr>
    <tr>
        <td colspan="5" class="textright">Total S/.</td>
        <td class="textright">'.$total.'</td>
    </tr>';
    /*agregamos al arrayData un elemento detalle,y le estamos colocando la variable $detalleTabla*/
    $arrayData['detalle'] = $detalleTabla;
    /*agregamos al arrayData un elemento totales,y le estamos colocando la variable $detalletotales*/
    $arrayData['totales'] = $detalleTotales;
    /*aca retornamos el $arrayData por medio de json_encode y con  JSON_UNESCAPED_UNICODE las tildes o caracteres vayan normal*/
    echo json_encode($arrayData,JSON_UNESCAPED_UNICODE);
  }else {
    //Si no ha devuelto ningun valor simplemente mostramos un mensaje de error
    echo 'error';
  }
  //cerramos la conexion
  mysqli_close($conexion);

  }
  exit;
}
//elimina el producto cargado si se cargo mal
if ($_POST['action'] == 'EliminarProductoDetalle') {
  if (empty($_POST['id_detalle'])){
    echo 'error';
  }else {
    $id_detalle = $_POST['id_detalle'];
    $id_usuario=md5($_SESSION['idUser']);
    $query_iva = mysqli_query($conexion, "SELECT iva FROM configuracion");
    $result_iva = mysqli_num_rows($query_iva);
    $query_detalle_tmp = mysqli_query($conexion, "CALL Eliminar_detalle_temporal($id_detalle,'$id_usuario')");
    $result = mysqli_num_rows($query_detalle_tmp);

    $detalleTabla = '';
    $sub_total = 0;
    $iva = 0;
    $total = 0;
      $data = "";
    $arrayDatadata = array();
    if ($result > 0) {
    if ($result_iva > 0) {
      $info_iva = mysqli_fetch_assoc($query_iva);
      $iva = $info_iva['iva'];
    }
    while ($data = mysqli_fetch_assoc($query_detalle_tmp)) {
      $precioTotal = round($data['cantidad'] * $data['precio_venta'], 2);
      $sub_total = round($sub_total + $precioTotal, 2);
      $total = round($total + $precioTotal, 2);

        $detalleTabla .= '<tr>
            <td>'.$data['codproducto'].'</td>
            <td colspan="2">'.$data['descripcion'].'</td>
            <td class="textcenter">'.$data['cantidad'].'</td>
            <td class="textright">'.$data['precio_venta'].'</td>
            <td class="textright">'.$precioTotal.'</td>
            <td>
                <a href="#" class="btn btn-danger" onclick="event.preventDefault();Eliminar_producto_detalle('.$data['correlativo'].');"><i class="fas fa-trash-alt"></i> Eliminar</a>
            </td>
        </tr>';
    }
    $impuesto = round($sub_total / $iva, 2);
    $tl_sniva = round($sub_total - $impuesto, 2);
    $total = round($tl_sniva + $impuesto, 2);

    $detalleTotales = '<tr>
        <td colspan="5" class="textright">Sub_Total S/.</td>
        <td class="textright">'.$impuesto.'</td>
    </tr>
    <tr>
        <td colspan="5" class="textright">Igv ('.$iva.')</td>
        <td class="textright">'. $tl_sniva.'</td>
    </tr>
    <tr>
        <td colspan="5" class="textright">Total S/.</td>
        <td class="textright">'.$total.'</td>
    </tr>';

    $arrayData['detalle'] = $detalleTabla;
    $arrayData['totales'] = $detalleTotales;

    echo json_encode($arrayData,JSON_UNESCAPED_UNICODE);
  }else {
    $data = 0;
  }
  mysqli_close($conexion);

  }
  exit;
}


//procesarVenta
if ($_POST['action'] =='procesarVenta') {
  if (empty($_POST['codcliente'])) {
    $codcliente=0;
  }else{
    $codcliente = $_POST['codcliente'];

    $id_usuario= md5($_SESSION['idUser']);
    $usuario = $_SESSION['idUser'];
    $query = mysqli_query($conexion, "SELECT * FROM detalle_temp WHERE id_usuario= '$id_usuario' ");
    $result = mysqli_num_rows($query);
  if ($result > 0) {
    $query_procesar = mysqli_query($conexion, "CALL procesar_venta($usuario,$codcliente,'$id_usuario')");
    $result_detalle = mysqli_num_rows($query_procesar);
    if ($result_detalle > 0) {
      $data = mysqli_fetch_assoc($query_procesar);
      echo json_encode($data,JSON_UNESCAPED_UNICODE);
    }else {
      echo "error";
    }
  }else {
    echo "error";
  }
  mysqli_close($conexion);
  exit;
}
}
}
?>
