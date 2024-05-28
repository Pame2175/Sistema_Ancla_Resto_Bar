<?php include_once "conex.php";
    
	$sentencia=$base->query("SELECT * FROM usuario;");
    $usuario=$sentencia->fetchAll(PDO::FETCH_OBJ);
 ?>