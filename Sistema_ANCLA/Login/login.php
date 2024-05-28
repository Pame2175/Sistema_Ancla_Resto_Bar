<?php
$alert = '';
//inicializamos la sesion
session_start();
//consultamos si la sesion esta activa,para que  no se pueda volver al login mientras este activo la sesion.
if (!empty($_SESSION['active'])) 
{
  header('location:../Pagina/menu/menu.php');
} else 
{
  //si existe post,significa que el usuario ha dado click en ingresar
  if (!empty($_POST)) 
  {
    //si esta vacio la variable usuario que esta siendo enviada por el metodo post o esta vacio la variable clave,se esta vacio mostrara un mensaje ingrese su usuario y contrasena
    if (empty($_POST['usuario']) || empty($_POST['clave'])) 
    {
      $alert = '<div class="alert alert-danger" role="alert">
  Ingrese su usuario y su clave
</div>';
    }
    /*sino esta vacio ocurrira lo siguiente,nos conectamos a la base de datos
    mediante el require_once*/
     else 
     {
      require_once "../conexion.php";
      //guardamos en la variable $usuario lo que esta siendo enviado por el metodo post desde el campo usuario
      //la funcion mysqli_real_escape_string evita introducir caracter especiales para que no se vulnerable
      $usuario = mysqli_real_escape_string($conexion, $_POST['usuario']);
      //guardamos en la variable $clave lo que esta siendo enviado por el metodo post desde el campo usuario
      //la funcion md5 envia la contrasena encriptada
      $clave = md5(mysqli_real_escape_string($conexion, $_POST['clave']));
      //realizamos una consulta a la base de datos,en donde solicitamos que seleccione toda la tabla usuario donde usuario=$usuario y clave=$clave
    $query = mysqli_query($conexion, "SELECT * FROM usuario WHERE usuario='$usuario' AND clave='$clave'");
      mysqli_close($conexion);
      //guardamos en la variable $resultado lo que devolvera la consulta guardada en $query
      $resultado = mysqli_num_rows($query);
      //si $resultado es mayor a eso,significa que existe un valor
      if ($resultado > 0) {
        //lo guardamos en un array,por medio de mysqli_fetch_array
        $dato = mysqli_fetch_array($query);
        //creamos la sesion
        $_SESSION['active'] = true;
        $_SESSION['idUser'] = $dato['idusuario'];
        $_SESSION['nombre'] = $dato['nombre'];
        $_SESSION['email'] = $dato['correo'];
        $_SESSION['user'] = $dato['usuario'];
        $_SESSION['rol'] = $dato['idrol'];
        $_SESSION['rol_name'] = $dato['rol'];
        header('location:../Pagina/menu/menu.php');
      } else 
      //sino se encontro los datos correctos mostrara por mensaje usuario o contrasena incorrecta
      {
        $alert = '<div class="alert alert-danger" role="alert">
              Usuario o Contraseña Incorrecta
            </div>';
        //destruimos la sesion
        session_destroy();
      }
    }
  }
}
?>
<!DOCTYPE html>
<html lang="es">

<head>

  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>SISTEMA ANCLA</title>

  <!-- Custom fonts for this template-->
  <link href="libreria/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  <!-- Custom styles for this template-->
  <link href="css/sb-admin-2.min.css" rel="stylesheet">

</head>

<body class="bg-gradient-secundario">

  <div class="container">
    <!-- Outer Row -->
    <div class="row justify-content-center">

      <div class="col-xl-10 col-lg-12 col-md-9">

        <div class="card o-hidden border-0 shadow-lg my-5">
          <div class="card-body p-0">
            <!-- Nested Row within Card Body -->
            <div class="row">
              <div class="col-lg-6 d-none d-lg-block ">
                <img src="imagen/fondo3.jpg" class="img-thumbnail">
              </div>
              <div class="col-lg-6">
                <div class="p-5">
                  <div class="text-center">
                    <h1 class="h4 text-gray-900 mb-4">Iniciar Sesión</h1>
                  </div>
                  <form class="user" method="POST">
                    <div class="form-group">
                      <label for="">Usuario</label>
                      <input type="text" class="form-control" placeholder="Usuario" name="usuario"></div>
                    <div class="form-group">
                      <label for="">Contraseña</label>
                      <input type="password" class="form-control" placeholder="Contraseña" name="clave">
                    </div>
                     <!-- muestro un mensaje de error si los datos son incorrectos,la logica significa que imprima si alert no esta vacio,o sea que alert contenga algo,si es cierto si alert contiene algo imprimira sino mostrara una comilla en blanco-->
                    <div class="alert"><?php echo isset($alert) ? $alert :' ';?></div>
                    <input type="submit" value="INGRESAR AL SISTEMA" class="btn btn-primary">
                  </form>
                </div>
              </div>
            </div>
          </div>
        </div>

      </div>

    </div>

  </div>

  <!-- Bootstrap core JavaScript-->
  <script src="libreria/jquery/jquery.min.js"></script>
  <script src="libreria/bootstrap/js/bootstrap.bundle.min.js"></script>
  <!-- Custom scripts for all pages-->
  <script src="js/sb-admin-2.min.js"></script>

</body>

</html>