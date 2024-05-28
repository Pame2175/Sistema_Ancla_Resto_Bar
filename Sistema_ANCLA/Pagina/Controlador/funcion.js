$(document).ready(function(){
  $('.btnMenu').click(function(e) {
    e.preventDefault();
    if($('nav').hasClass('viewMenu')) {
      $('nav').removeClass('viewMenu');
    }else {
      $('nav').addClass('viewMenu');
    }
  });

  $('nav ul li').click(function() {
    $('nav ul li ul').slideUp();
    $(this).children('ul').slideToggle();
  });
// activa campos para registrar Cliente
$('.btn_new_cliente').click(function(e){
//la funcion preventDefault se utiliza para prevenir que se recarge la pagina 
  e.preventDefault();
/*
A este elemento que es un id= nom_cliente 
le estamos removiendo el atributo disabled con la funcion removeattr 
y lo mismo estamos haciendo con los demas elementos
*/
  $('#nom_cliente').removeAttr('disabled');
  $('#cel_cliente').removeAttr('disabled');
  $('#dir_cliente').removeAttr('disabled');


});
/*Buscaremos el cliente con su numero de cedula 
para traer de la bd si existe*/
/*usaremos el evento keyup ,este evento quiere decir que cuando presionemos
y levantemos la tecla es que se va a ejecutar lo que vayemos a colocar aca
que este caso sera una funcion
*/
$('#ci_cliente').keyup(function(e) {
  e.preventDefault();/*la funcion preventdefault se utilizar 
  para prevenir que se recarge la pagina*/
  /* aca declaramos la variable cl ,la cual por medio
  de la propiedad de val();va a extraer el valor ;y el valor de quien?
  y pues de this ,this quiere decir de este elemento y este elemento
  es el mismo elemento que estamos escribiendo que es la variable cl.
  */
  var cl = $(this).val();
  var action ='BuscarCliente';
  $.ajax({
    /*luego por medio de ajax,desde la url nos dirigirenos a la direccion
    ../Modelo/modal.php para realizar que por medio de la action podamos obtener los datos
    del cliente
    */
    url: '../Modelo/modelo.php',
    type: "POST",
    async: true,
    /*
    y va a llevar la data de la variable action:action y 
    cliente:cl
    */
    data: 
    {//declaramos la variable que sera enviada por metodo post
      action:action,
      cliente:cl
    },
    success: function(response) 
    {
    if (response == 0) 
      {
      $('#nom_cliente').val('');
      $('#dir_cliente').val('');
      $('#cel_cliente').val('');
      // mostar boton agregar
       $('.btn_new_cliente').slideDown();
      }
      else 
      {
      //Utilice la función JavaScript JSON.parse()
      //para convertir texto en un objeto JavaScript:
      var data = $.parseJSON(response);
      $('#idcliente').val(data.idcliente);
      $('#nom_cliente').val(data.nombre);
      $('#dir_cliente').val(data.direccion);
      $('#cel_cliente').val(data.celular);
      // ocultar boton Agregar
      $('.btn_new_cliente').slideUp();

      // Bloque campos
      $('#nom_cliente').attr('disabled','disabled');
      $('#dir_cliente').attr('disabled','disabled');
      $('#cel_cliente').attr('disabled','disabled');
      // ocultar boto Guardar
      $('#div_registro_cliente').slideUp();
      }
    },
    error:function(error){

    },
  });

});
/*Buscaremos el producto por el 
codigo de cada alimento para mostrar en la tabla*/
$('#txt_cod_producto').keyup(function(e) {
  e.preventDefault();
  var productos = $(this).val();
  if (productos == "") {
    $('#txt_descripcion').html('-');
    $('#txt_existencia').html('-');
    $('#txt_cant_producto').val('0');
    $('#txt_precio').html('0.00');
    $('#txt_precio_total').html('0.00');

    //Bloquear Cantidad
    $('#txt_cant_producto').attr('disabled', 'disabled');
    // Ocultar Boto Agregar
    $('#add_product_venta').slideUp();
  }
  var action ='infoProducto';
  if (productos!='') 
  {
  $.ajax({
    url: '../Modelo/modelo.php',
    type: "POST",
    async: true,
    data: {
      action:action,
      producto:productos
    },
    success: function(response){
      if(response == 0) {
        $('#txt_descripcion').html('-');
        $('#txt_existencia').html('-');
        $('#txt_cant_producto').val('0');
        $('#txt_precio').html('0.00');
        $('#txt_precio_total').html('0.00');

        //Bloquear Cantidad
        $('#txt_cant_producto').attr('disabled','disabled');
        // Ocultar Boto Agregar
        $('#add_product_venta').slideUp();


      }else{

        var info = JSON.parse(response);
        $('#txt_descripcion').html(info.descripcion);
        $('#txt_existencia').html(info.existencia);
        $('#txt_cant_producto').val('1');
        $('#txt_precio').html(info.precio);
        $('#txt_precio_total').html(info.precio);
        // Activar Cantidad
        $('#txt_cant_producto').removeAttr('disabled');
        // Mostar boton Agregar
        $('#add_product_venta').slideDown();

      }
    },
    error: function(error) {
    }
  });
  $('#txt_descripcion').html('-');
  $('#txt_existencia').html('-');
  $('#txt_cant_producto').val('0');
  $('#txt_precio').html('0.00');
  $('#txt_precio_total').html('0.00');

  //Bloquear Cantidad
  $('#txt_cant_producto').attr('disabled','disabled');
  // Ocultar Boto Agregar
  $('#add_product_venta').slideUp();

  }
});
// facturar venta
//cuando demos click se ejecutara toda la funcion creada
$('#btn_facturar_venta').click(function(e) 
{
  e.preventDefault();
  /*tenemos una variable rows que esta almacenando 
  la cantidad de filas,que va a contar lo que tiene detalle venta*/
  var rows = $('#detalle_venta tr').length;
  /*
  aca se evalua es mayor a 0, si es mayor a cero significa que tiene datos
  */
  if (rows>0) {
    //a esta variable le asignamos procesar venta
    var action ='procesarVenta';
    //en la variable codcliente se guardara el id del cliente
    var codcliente =$('#idcliente').val();
    $.ajax({
      url:'../Modelo/modelo.php',
      type:'POST',
      async:true,
      data: {
        action:action,
        codcliente:codcliente
      },
      success: function(response) {
      if (response!=0) {
        var info =JSON.parse(response);
        //console.log(info);
        generarPDF(info.codcliente,info.noticket);
        location.reload();
      }else {
        console.log('no hay dato');
      }
        
      },
      
      error: function(error) {

      }
    });
  }
});
//Ver ticket
$('.vista_ticket').click(function(e) {
  e.preventDefault();
 /*obtenemos el codcliente por medio del elemento
  this que hace referencia al elemento cl*/
  var codCliente = $(this).attr('cl');
  /*obtenemos el codcliente por medio del elemento
  this que hace referencia al elemento cl*/
  var noticket= $(this).attr('f');
/* se llama al metodo generarPDF y se le pasa como parametro el codcliente
 y el noticket obtenido*/
  generarPDF(codCliente,noticket);
});

// Agregar producto al detalle_venta
$('#add_product_venta').click(function(e) {
  e.preventDefault();
  /*se evalua si el campo cantidad sea mayor a 0 de esa forma 
  se ejecuta la condicion,de lo contrario no hace nada
  */
  if ($('#txt_cant_producto').val() > 0) 
  {
    //La variable codproducto va almacenar lo que tenga el campo de producto
    var codproducto = $('#txt_cod_producto').val();
    //La variable cantidad va almacenar lo que tenga el campo de cantidad
    var cantidad = $('#txt_cant_producto').val();
    //creamos la variable la cual almacenara addProductoDetalle
    var action ='AgregarProductoDetalle';
    $.ajax({
      //los datos se enviara al modelo.php por metodo post
      url: '../Modelo/modelo.php',
      type: 'POST',
      //se ejecutara de forma asincrona
      async: true,
      data: {
        //creo variable que se enviaran por el metodo post
        action:action,
        producto:codproducto,
        cantidad:cantidad
      },
      success: function(response) {
        if (response != 'error') 
        {
          var info = JSON.parse(response);
          //vamos agregar al id=detalle_venta que esta declarado en nuevaventa
          $('#detalle_venta').html(info.detalle);
          //vamos agregar al id=detalle_totales que esta declarado en nuevaventa
          $('#detalle_totales').html(info.totales);
          /*luego limpiamos los campos
          despues de haberle dado click en agregar,
          para volver a ingresar otro producto*/
          $('#txt_cod_producto').val('');
          $('#txt_descripcion').html('-');
          $('#txt_existencia').html('-');
          $('#txt_cant_producto').val('0');
          $('#txt_precio').html('0.00');
          $('#txt_precio_total').html('0.00');

          // se Bloquea el campo cantidad
          $('#txt_cant_producto').attr('disabled','disabled');

          // se oculta el boton agregar
          $('#add_product_venta').slideUp();
      }
      else{
        //sino hay datos mostrara un mensaje no hay datos
        console.log('No hay dato');
      }
      Generar_Venta();
     }
    });
  }
});
});//fin ready
//Ver Factura

function generarPDF(cliente,ticket) {
  var ancho = 1000;
  var alto = 800;
  //calcular posicion x, y para centrar la ventana
  var x = parseInt((window.screen.width/2) - (ancho / 2));
  var y = parseInt((window.screen.height/2) - (alto / 2));

  $url = '../../ticket/generaticket.php?cl='+cliente+'&f='+ticket;
  window.open($url,"ticket","left="+x+",top="+y+",height="+alto+",width="+ancho+",scrollbar=si,location=no,resizable=si,menubar=no");
}
// si no hay nada para generar se ocultara el  boton 
function Generar_Venta() {
  /*ingresa a detalle_venta y se dirigi a las filas por medio de tr,
  y va a contar con length preguntando si es mayor a 0 */
  if ($('#detalle_venta tr').length > 0){
    /*si tiene informacion muestra el boton 
    generarventa y anular venta por medio del id*/
    $('#btn_facturar_venta').show();
  }else {
    /*
    de lo contrario oculta los botones
    */
    $('#btn_facturar_venta').hide();
  }
}

/*se crea la funcion Eliminar_producto_detalle 
que recibe como parametro el correlativo*/
function Eliminar_producto_detalle(correlativo) 
{
 //creamos la variable la cual almacenara EliminarProductoDetalle
  var action = 'EliminarProductoDetalle';
  //creamos la variable la cual almacenara el correlativo
  var id_detalle = correlativo;
  $.ajax({
    //enviamos por medio de ajax los datos
    url: '../Modelo/modelo.php',
    type: "POST",
    async: true,
    data: {
      //se envia estos datos por metodo post
      action:action,
      id_detalle:id_detalle},
    success: function(response) 
    {
      /*si la respuesta no es igual a cero ,
      eso significa que tiene datos el detalle y totales y se limpian los campos del 
      formulario*/
        if (response != 0) {
        var info = JSON.parse(response);
        $('#detalle_venta').html(info.detalle);
        $('#detalle_totales').html(info.totales);
        $('#txt_cod_producto').val('');
        $('#txt_descripcion').html('-');
        $('#txt_existencia').html('-');
        $('#txt_cant_producto').val('0');
        $('#txt_precio').html('0.00');
        $('#txt_precio_total').html('0.00');

        // se Bloquea el campo cantidad
        $('#txt_cant_producto').attr('disabled','disabled');

        // se oculta el boton agregar
        $('#add_product_venta').slideUp();
      }
      else 
      {
        //si la respuesta es igual a cero mostrara la tabla sin datos
        $('#detalle_venta').html('');
        $('#detalle_totales').html('');


      }
      Generar_Venta();
    },
    error: function(error) {
      
    }
  });
}
