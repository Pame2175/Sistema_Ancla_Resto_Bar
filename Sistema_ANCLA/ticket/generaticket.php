<?php
//se inicia la sesion
session_start();
//si la sesion esta activa
if(empty($_SESSION['active']))
{
//redireccionara al menu principal
header('location: ../Pagina/menu/menu.php');
}
//llamado a mi conexion por medio de include
include "../conexion.php";
//tambien llamada a mi libreria pdf por medio de require_once
require_once '../pdf/vendor/autoload.php';
use Dompdf\Dompdf;
/*condicio si lo que recibo esta vacio,tanto cl o f,mostrara un mensaje no es posible generar el ticket*/
if(empty($_REQUEST['cl']) || empty($_REQUEST['f']))
{
echo "No es posible generar el ticket.";
}else
//sino viene vacio,significa que trae datos entonces ocurrira lo siguiente
{
	//guardo en la variable $codCliente lo que obtuve en mi condicion de $_REQUEST['cl']; 
	$codCliente = $_REQUEST['cl'];
	//tambien guardo en la variable $noticket lo que obtuve en condicion  $_REQUEST['f'];
	$noticket = $_REQUEST['f'];
	//creo la variable result ,que almacenara la consulta que se vaya realizando
	$result='';
	/*otra variable denominada $result_detalle la cual almacenara la consulta de $query_productos ,para luego pormedio de un if realizar la carga de los datos*/
	$result_detalle='';
	//realizo una consulta sql,la cual almaceno en la variable $query_config,en la cual obtengo todos los datos de la tabla de configuracion
	$query_config=mysqli_query($conexion,"SELECT * FROM configuracion");
	//guardo la consulta realizada en la variable $result_config
	$result_config=mysqli_num_rows($query_config);
	//realizo una condicion,diciendo si la $result_config>0,la cual almacena los datos de la consulta realiza
	if($result_config>0)
	{
	/*si es mayor a 0,significa que hay datos,y lo guardo en la variable $configuracion */
	$configuracion = mysqli_fetch_assoc($query_config);
	}
 //luego realizo una consulta sql,en la cual obtengo,noticket,la fecha cargada de forma automatica,el codcliente,el estado,el nombre,de la tabla ticket,y de la tabla usuario,usuario,de la tablacliente codcliente,en donde el noticket sea igual 
$query = mysqli_query($conexion,"SELECT f.noticket, DATE_FORMAT(f.fecha, '%d/%m/%Y') as fecha, DATE_FORMAT(f.fecha,'%H:%i:%s') as  hora, f.codcliente, f.estado,
		v.nombre as vendedor,
		cl.ci, cl.nombre, cl.direccion,cl.celular
		FROM ticket f
		INNER JOIN usuario v
		ON f.usuario = v.idusuario
		INNER JOIN cliente cl
		ON f.codcliente = cl.idcliente
		WHERE f.noticket = $noticket AND f.codcliente = $codCliente 
		 AND f.estado != 10 ");
		$result = mysqli_num_rows($query);
		if($result>0)
		{
			$factura = mysqli_fetch_assoc($query);
			$no_ticket = $factura['noticket'];

		$query_productos = mysqli_query($conexion,"SELECT p.descripcion,dt.cantidad,dt.precio_venta,(dt.cantidad * dt.precio_venta) as precio_total
		FROM ticket f
		INNER JOIN detalleticket dt
		ON f.noticket = dt.noticket
		INNER JOIN producto p
		ON dt.codproducto = p.codproducto
		WHERE f.noticket = $no_ticket ");
		$result_detalle = mysqli_num_rows($query_productos);
		ob_start();
		//aca llamo a la carpeta ticket,para poder obtener y mostrar los datos en la pagina pdf
		include(dirname('__FILE__').'/ticket.php');
		 $html = ob_get_clean();
		// se instancia y se usa la clase dompdf
		$dompdf = new Dompdf();

		$dompdf->loadHtml($html);
		// se configura el tamaño y la orientación del papel
		$dompdf->set_paper(array(0,0,210,1000));
		// Renderiza el HTML como PDF
		$dompdf->render();
		// Envía el PDF generado al navegador
		$dompdf->stream('ticket_'.$noticket.'.pdf',array('Attachment'=>0));
		exit;
		}
	}

?>
