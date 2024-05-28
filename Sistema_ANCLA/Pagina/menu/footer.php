<!--esto seria el pie de pagina-->
<footer class="main-footer">
  <!--mostramos el autor del Sistema y los derechos reservados-->
    <strong>Copyright 2021-2025 <a href="">Ancla Resto Bar</a>.</strong>
    Todos los derechos reservados.
    <div class="float-right d-none d-sm-inline-block">
    </div>
  </footer>
  <aside class="control-sidebar control-sidebar-dark">
  </aside>
</div>
<!--aca incluimos todos los estilos ya sea jquery,js,datatables y las funciones creadas para el correcto funcionamiento del Sistema-->
<script src="../../Plantilla/plugins/jquery/jquery.min.js"></script>
<script src="../../Plantilla/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="../../Plantilla/plugins/daterangepicker/daterangepicker.js"></script>
<script src="../../Plantilla/dist/js/adminlte.js"></script>
<script src="../../Plantilla/js/jquery.dataTables.min.js"></script>
<script src="../../Plantilla/dist/js/demo.js"></script>
<!-- se llama a la libreria de datatable -->
<script src="../../Plantilla/datatables/DataTable/js/jquery.dataTables.min.js"></script>
<script src="../Controlador/funcion.js"> </script>
<!--aca llama a datatables y le pasamos el nombre de la tabla-->
<script type="text/javascript" >
$(document).ready(function() {
    $('#table').DataTable( {
    language:{
          url: 'https://cdn.datatables.net/plug-ins/1.10.24/i18n/Spanish.json'
        }
    });

});
</script>
</body>
</html>