<?php
//se declara la variable subtotal
$subtotal   = 0;
//se declara la variable iva
$iva        = 0;
//se declara la variable la variable impuesto
$impuesto   = 0;
//se declara el total sin iva
$tl_sniva   = 0;
$total      = 0;
$medidaTicket=250;
?>
<!DOCTYPE html>
<html>
<head>
   <style >

* {
    font-size: 12px;
    font-family: 'DejaVu Sans', serif;
    }

    h1 {
        font-size: 13px;
        text-align: center;
        }

    .ticket {
        margin: 2px;
        }

    td,
    th,
    tr,
    table {
    border-top: 1px solid black;
    border-collapse: collapse;
    margin: 0 auto;
    font-size: 14px;
    }
    p,
    {
    font-size: 16px;  
    }
    span,{
        font-size: 14px;
        }

    td.precio {
        text-align: right;
        font-size: 14px;
        }

        td.cantidad {
            font-size: 14px;
        }

        td.producto {
            text-align: center;
            font-size: 14px;
        }

        th {
            text-align: center;

        }


        .centrado {
            text-align: center;
            align-content: center;
        }

        .ticket {
            width: <?php echo $medidaTicket ?>px;
            max-width: <?php echo $medidaTicket ?>px;
        }

        img {
            max-width: inherit;
            width: inherit;
        }

        * {
            margin: 0;
            padding: 0;
        }

        .ticket {
            margin: 15px;
            padding: 8px;
        }

        body {
            text-align: center;
        }
        </style>
</head>

<body>
    <div class="ticket centrado">
    <img src="img/lo1.jpg" style="width: 50px;"/>  
    <h1>ANCLA RESTO BAR</h1>
    <p>TICKET#: <strong><?php echo $factura['noticket']; ?></strong></p>
    <p>CI:<?php echo $factura['ci']; ?></p>
    <p>Nombre:<?php echo $factura['nombre']; ?></p>
    <p>Celular:<?php echo $factura['celular']; ?></p>
    <p>Dirección:<?php echo $factura['direccion']; ?></p>
    <p>Fecha:<?php date_default_timezone_set("America/Asuncion");$fechaactual=date("Y-m-d H:i:s");echo $fechaactual;?></p>  
   <table>
    <thead>
        <tr>
        
        <th class="textright">Cant.&nbsp;</th>
        <th class="textright">Des.</th>
        <th class="textright">P.U</th>
        <th class="textright">P.Total</th>
        </tr>
    </thead>
    <tbody>
    <?php
    if ($result_detalle>0)
        {
         while ($row=mysqli_fetch_assoc($query_productos)) 
        {
        ?>
        <tr> 
        <td class="textcenter"><?php echo $row['cantidad']; ?></td>
        <td><?php echo $row['descripcion']; ?></td>
        <td class="textright"><?php echo $row['precio_venta']; ?></td>
        <td class="textright"><?php echo $row['precio_total']; ?></td>
        </tr>
        <?php
        $precio_total = $row['precio_total'];
         $subtotal = round($subtotal + $precio_total, 2);
        }
        } 
        if($result_config>0) {
            $iva = $configuracion['iva'];
            } 
            $impuesto=round($subtotal / $iva, 2);
            $tl_sniva=round($subtotal - $impuesto, 2);
            $total=round($tl_sniva + $impuesto, 2); 
           ?>
          
        </tbody>
        <tfoot>
        <tr>
        <td colspan="3" class="textright"><span>&nbsp;&nbsp;&nbsp;TOTAL</span></td>
        <td class="textright"><span><?php echo $total; ?></span></td>
                </tr>
            </tfoot>
    </table>
</div>
</body>
</html>