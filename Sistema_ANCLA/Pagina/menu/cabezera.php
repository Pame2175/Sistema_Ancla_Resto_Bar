<?php
//se inicia la sesion
session_start();
//si esta activo ,redireccionara al menu principal
if (empty($_SESSION['active'])) {
  header('location:./menu.php');
}

?>
<!DOCTYPE html>
<html lang="en">
<head>
  <!--Aca se incluye todas las carpeta que contiene es el estilo y algunos plugins-->
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>SISTEMA|ANCLA</title>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
  <link rel="stylesheet" href="../../Plantilla/plugins/fontawesome-free/css/all.min.css">
  <link rel="stylesheet" href="../../Plantilla/datatables/DataTable/css/dataTables.bootstrap4.min.css">
  <!-- llamada al estilo css de datatables -->
  <link rel="stylesheet" href="../../Plantilla/datatables/DataTable/css/dataTables.bootstrap.min.css">
  <link rel="stylesheet" href="../../Plantilla/plugins/icheck-bootstrap/icheck-bootstrap.min.css">
  <link rel="stylesheet" href="../../Plantilla/dist/css/adminlte.min.css">
  <link rel="stylesheet" href="../../Plantilla/plugins/daterangepicker/daterangepicker.css">

</head>
<!--este es el cuerpo del contenido de la pagina-->
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">
  <nav class="main-header navbar navbar-expand navbar-white navbar-light">
    <ul class="navbar-nav">
    <li class="nav-item">
    <a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="fas fa-bars"></i></a>
    </li>
    </ul>
    <ul class="navbar-nav ml-auto">
      <li class="nav-item dropdown">
      <a class="nav-link" data-toggle="dropdown" href="#">
      <i class="fa fa-user"></i>
      </a>
      <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
      <div class="dropdown-divider"></div>
        <a href="../Salir/cerrar_sesion.php" class="dropdown-item">
        <i class="fas fa-user"></i> Cerrar Sesion
        </a>
        </div>
      </div>
    </li>
    </ul>
  </nav>
  <!--aca muestra un titulo de sistema ancla el cual redirecciona al menu principal-->
  <aside class="main-sidebar sidebar-dark-primary elevation-4">
    <a href="../menu/menu.php" class="brand-link">
      <img src="../../Plantilla/dist/img/user9-160x160.jpg" alt="AdminLTE Logo" class="brand-image img-circle elevation-3" style="opacity: .8">
      <span class="brand-text font-weight-light">Sistema Ancla</span>
    </a>
    <div class="sidebar">
      <!--en esta parte se declara todas las lista de menu de acceso al contenido-->
      <nav class="mt-2">
      <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
      <li class="nav-item menu-open">
      <a href="#" class="nav-link active">
        <!--tenemos el modulo ventas-->
      <i class="fas fa-align-justify"></i>
      <p>
      Ventas
      <i class="right fas fa-angle-left"></i>
      </p>
      </a>
      <!--seccion para realizar nuevaventa-->
      <ul class="nav nav-treeview">
      <li class="nav-item">
      <a href="../Ventas/Nuevaventa.php">
      <i class="fas fa-anchor"></i></i><span >Nueva Venta</span>
      </a>
      </li>
      <!--seccion para ver las lista de ventas-->
      <li class="nav-item">
      <a href="../Ventas/Ventas.php">
      <i class="fas fa-anchor"></i></i><span>Lista de Ventas</span>
      </a>
      </li>
      </ul>
      </li>
      <!--seccion el modulo de producto-->
      <li class="nav-item menu-open">
      <a href="#" class="nav-link active">
      <i class="fab fa-product-hunt"></i>
      <p>
       Productos
      <i class="right fas fa-angle-left"></i>
      </p>
      </a>
      <!--seccion para agregar nuevo producto-->
      <ul class="nav nav-treeview">
      <li class="nav-item">
      <a href="../Productos/nuevoproducto.php">
      <i class="fas fa-anchor"></i></i><span>Nuevo Producto</span>
      </a>
      </li>
      <!--seccion para ver las lista de productos-->
      <li class="nav-item">
      <a href="../Productos/productos.php">
      <i class="fas fa-anchor"></i><span>Lista de Productos</span>
      </a>
      </li>
      </ul>
      </li>
      <!--seccion del modulo usuarios-->
      <li class="nav-item menu-open">
      <a href="#" class="nav-link active">
      <i class="far fa-address-card"></i>
      <p>
      Usuarios
      <i class="right fas fa-angle-left"></i>
      </p>
      </a>
      <!--seccion para agregar nuevo usuario-->
      <ul class="nav nav-treeview">
      <li class="nav-item">
      <a href="../Usuarios/registro_usuario.php">
      <i class="fas fa-anchor"></i></i><span>Nuevo Usuario</span>
      </a>
      </li>
      <!--seccion para ver las lista de usuarios-->
      <li class="nav-item">
      <a href="../Usuarios/lista_usuarios.php">
      <i class="fas fa-anchor"></i><span>Lista de Usuario</span>
      </a>
      </li>
      </ul>
      </li>
       <!--seccion el modulo de cliente-->
      <li class="nav-item menu-open">
      <a href="#" class="nav-link active">
      <i class="far fa-address-card"></i>
      <p>
       Clientes
      <i class="right fas fa-angle-left"></i>
      </p>
      </a>
      <!--seccion para agregar nuevo cliente-->
      <ul class="nav nav-treeview">
      <li class="nav-item">
      <a href="../Cliente/registro_cliente.php">
      <i class="fas fa-anchor"></i></i><span>Nuevo Cliente</span>
      </a>
      </li>
      <!--seccion para ver las lista de clientes-->
      <li class="nav-item">
      <a href="../Cliente/lista_clientes.php">
      <i class="fas fa-anchor"></i><span>Lista de Clientes</span>
      </a>
      </li>
      </ul>
      </li>
      <!--seccion para ver el modulo de proveedor-->
       <li class="nav-item menu-open">
      <a href="#" class="nav-link active">
        <i class="far fa-address-card"></i>
        <p>
          Proveedor
        <i class="right fas fa-angle-left"></i>
        </p>
        </a>
        <!--seccion para agregar nuevo proveedor-->
        <ul class="nav nav-treeview">
        <li class="nav-item">
        <a href="../Proveedores/registro_proveedores.php"">
        <i class="fas fa-anchor"></i></i><span>Nuevo Proveedor</span>
        </a>
        </li>
        <!--seccion para ver las lista de proveedor-->
        <li class="nav-item">
        <a href="../Proveedores/lista_proveedores.php"">
        <i class="fas fa-anchor"></i><span>Lista de Proveedores</span>
        </a>
        </li>
        </ul>
  </li>
</ul>
</nav>
</div>
</aside>