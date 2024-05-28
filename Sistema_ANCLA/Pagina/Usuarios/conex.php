<?php
$contrasena="";
$usuario="root";
$nombrebd="sistemas";
try{
$base= new PDO('mysql:host=localhost;dbname='.$nombrebd,$usuario,$contrasena);
}
catch (PDOException $e) {
    print "¡Error!: ".$e->getMessage()."<br/>";
}
?>