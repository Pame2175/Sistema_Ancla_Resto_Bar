<?php
 //se inicia la sesion
    session_start();
   //por de la funcion destroy se destruye la sesion
    session_destroy();
 //se redireciona la pagina al portal de login
    header('location:../../Login/login.php');
?>
