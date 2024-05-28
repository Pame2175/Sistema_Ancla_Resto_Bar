-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 24-07-2021 a las 01:53:46
-- Versión del servidor: 10.4.19-MariaDB
-- Versión de PHP: 7.3.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bd_ancla`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Agregar_detalle_temporal` (IN `codigo` INT, IN `cantidad` INT, IN `id_usuario` VARCHAR(50))  BEGIN
    DECLARE precio_actual decimal(10,2);
    SELECT precio INTO precio_actual FROM producto WHERE codproducto=codigo;
    INSERT INTO detalle_temp(id_usuario,codproducto, cantidad, precio_venta) VALUES (id_usuario,codigo, cantidad, precio_actual);
    SELECT tmp.correlativo,tmp.codproducto, p.descripcion, tmp.cantidad, tmp.precio_venta FROM detalle_temp tmp 
    INNER JOIN producto p 
    ON tmp.codproducto = p.codproducto
    WHERE tmp.id_usuario=id_usuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Eliminar_detalle_temporal` (`id_detalle` INT, `id_usuario` VARCHAR(100))  BEGIN
    DELETE FROM detalle_temp WHERE correlativo = id_detalle;
    SELECT tmp.correlativo, tmp.codproducto, p.descripcion, tmp.cantidad, tmp.precio_venta FROM detalle_temp tmp 
    INNER JOIN producto p 
    ON tmp.codproducto = p.codproducto WHERE tmp.id_usuario =id_usuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procesar_venta` (IN `cod_usuario` INT, IN `cod_cliente` INT, IN `id_usuario` VARCHAR(100))  BEGIN
DECLARE ticket INT;
DECLARE registros INT;
DECLARE total DECIMAL(10,2);
DECLARE nueva_existencia int;
DECLARE existencia_actual int;

DECLARE tmp_cod_producto int;
DECLARE tmp_cant_producto int;
DECLARE a int;
SET a = 1;

CREATE TEMPORARY TABLE tabla_temporal_id_usuario(
	id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cod_prod BIGINT,
    cant_prod int);
SET registros = (SELECT COUNT(*) FROM detalle_temp WHERE id_usuario = id_usuario);
IF registros > 0 THEN
INSERT INTO tabla_temporal_id_usuario(cod_prod, cant_prod) SELECT codproducto, cantidad FROM detalle_temp WHERE id_usuario =id_usuario;
INSERT INTO ticket (usuario,codcliente) VALUES (cod_usuario, cod_cliente);
SET ticket = LAST_INSERT_ID();

INSERT INTO detalleticket(noticket,codproducto,cantidad,precio_venta) SELECT (ticket) AS noticket, codproducto, cantidad,precio_venta FROM detalle_temp
WHERE id_usuario =id_usuario;
WHILE a <= registros DO
	SELECT cod_prod, cant_prod INTO tmp_cod_producto,tmp_cant_producto FROM tabla_temporal_id_usuario WHERE id = a;
    SELECT existencia INTO existencia_actual FROM producto WHERE codproducto = tmp_cod_producto;
    SET nueva_existencia = existencia_actual - tmp_cant_producto;
    UPDATE producto SET existencia = nueva_existencia WHERE codproducto = tmp_cod_producto;
    SET a=a+1;
END WHILE;
SET total = (SELECT SUM(cantidad * precio_venta) FROM detalle_temp WHERE id_usuario = id_usuario);
UPDATE ticket SET totalticket = total WHERE noticket =ticket;
DELETE FROM detalle_temp WHERE id_usuario =id_usuario;
TRUNCATE TABLE tabla_temporal_id_usuario;
SELECT * FROM ticket WHERE noticket= ticket;
ELSE
SELECT 0;
END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `idcliente` int(11) NOT NULL,
  `ci` int(255) NOT NULL,
  `nombre` varchar(255) COLLATE utf8_spanish_ci NOT NULL,
  `direccion` varchar(255) COLLATE utf8_spanish_ci NOT NULL,
  `celular` int(255) NOT NULL,
  `usuario_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`idcliente`, `ci`, `nombre`, `direccion`, `celular`, `usuario_id`) VALUES
(9, 5258613, 'pamela gonza', 'centroa', 97854, 19);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracion`
--

CREATE TABLE `configuracion` (
  `id` int(11) NOT NULL,
  `dni` int(11) NOT NULL,
  `nombre` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `razon_social` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `telefono` int(11) NOT NULL,
  `email` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `direccion` text COLLATE utf8_spanish_ci NOT NULL,
  `iva` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `configuracion`
--

INSERT INTO `configuracion` (`id`, `dni`, `nombre`, `razon_social`, `telefono`, `email`, `direccion`, `iva`) VALUES
(1, 8293845, 'Juan', 'Ancla', 98547, 'jaun@gmai.com', 'encarnacion', '11.00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalleticket`
--

CREATE TABLE `detalleticket` (
  `correlativo` bigint(20) NOT NULL,
  `noticket` bigint(11) NOT NULL,
  `codproducto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `detalleticket`
--

INSERT INTO `detalleticket` (`correlativo`, `noticket`, `codproducto`, `cantidad`, `precio_venta`) VALUES
(141, 95, 75, 1, '15000.00'),
(142, 96, 75, 2, '15000.00'),
(143, 97, 75, 1, '15000.00'),
(144, 98, 75, 1, '15000.00'),
(145, 99, 65, 1, '7000.00'),
(146, 100, 56, 1, '35000.00'),
(147, 100, 12, 1, '32000.00'),
(148, 101, 2, 1, '35000.00'),
(149, 101, 23, 1, '10000.00'),
(150, 101, 5, 1, '35000.00'),
(151, 102, 25, 1, '50000.00'),
(152, 102, 8, 1, '30000.00'),
(153, 102, 14, 1, '32000.00'),
(154, 103, 14, 1, '32000.00'),
(155, 103, 36, 1, '12000.00'),
(156, 103, 3, 1, '37000.00'),
(157, 104, 2, 1, '35000.00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_temp`
--

CREATE TABLE `detalle_temp` (
  `correlativo` int(11) NOT NULL,
  `id_usuario` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `codproducto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entrada`
--

CREATE TABLE `entrada` (
  `correlativo` int(11) NOT NULL,
  `codproducto` int(11) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `cantidad` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `usuario_id` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `entrada`
--

INSERT INTO `entrada` (`correlativo`, `codproducto`, `fecha`, `cantidad`, `precio`, `usuario_id`) VALUES
(154, 75, '2021-06-05 11:42:36', 15, '15000.00', 19),
(192, 1, '2021-06-20 19:19:33', 99, '42000.00', 19),
(193, 2, '2021-06-20 19:19:33', 95, '35000.00', 19),
(194, 3, '2021-06-20 19:19:33', 93, '37000.00', 19),
(195, 4, '2021-06-20 19:19:33', 100, '35000.00', 19),
(196, 5, '2021-06-20 19:19:33', 98, '35000.00', 19),
(197, 6, '2021-06-20 19:19:33', 94, '32000.00', 19),
(198, 7, '2021-06-20 19:19:33', 98, '35000.00', 19),
(199, 8, '2021-06-20 19:19:33', 99, '30000.00', 19),
(200, 9, '2021-06-20 19:19:33', 100, '32000.00', 19),
(201, 10, '2021-06-20 19:19:33', 97, '30000.00', 19),
(202, 11, '2021-06-20 19:19:33', 100, '30000.00', 19),
(203, 12, '2021-06-20 19:19:33', 100, '32000.00', 19),
(204, 13, '2021-06-20 19:19:33', 100, '32000.00', 19),
(205, 14, '2021-06-20 19:19:33', 96, '32000.00', 19),
(206, 15, '2021-06-20 19:19:33', 99, '32000.00', 19),
(207, 16, '2021-06-20 19:19:33', 90, '50000.00', 19),
(208, 17, '2021-06-20 19:19:33', 100, '55000.00', 19),
(209, 18, '2021-06-20 19:19:33', 99, '60000.00', 19),
(210, 19, '2021-06-20 19:19:33', 96, '30000.00', 19),
(211, 20, '2021-06-20 19:19:33', 99, '17000.00', 19),
(212, 21, '2021-06-20 19:19:33', 100, '8000.00', 19),
(213, 22, '2021-06-20 19:19:33', 93, '12000.00', 19),
(214, 23, '2021-06-20 19:19:33', 100, '10000.00', 19),
(215, 24, '2021-06-20 19:19:33', 100, '25000.00', 19),
(216, 25, '2021-06-20 19:19:33', 95, '50000.00', 19),
(217, 26, '2021-06-20 19:19:33', 100, '20000.00', 19),
(218, 27, '2021-06-20 19:19:33', 98, '10000.00', 19),
(219, 28, '2021-06-20 19:19:33', 100, '10000.00', 19),
(220, 29, '2021-06-20 19:19:33', 97, '10000.00', 19),
(221, 30, '2021-06-20 19:19:33', 99, '12000.00', 19),
(222, 31, '2021-06-20 19:19:33', 98, '40000.00', 19),
(223, 32, '2021-06-20 19:19:33', 85, '3000.00', 19),
(224, 33, '2021-06-20 19:19:33', 100, '6000.00', 19),
(225, 34, '2021-06-20 19:19:33', 91, '20000.00', 19),
(226, 35, '2021-06-20 19:19:33', 93, '15000.00', 19),
(227, 36, '2021-06-20 19:19:33', 96, '12000.00', 19),
(228, 37, '2021-06-20 19:19:33', 100, '13000.00', 19),
(229, 38, '2021-06-20 19:19:33', 100, '17000.00', 19),
(230, 39, '2021-06-20 19:19:33', 100, '15000.00', 19),
(231, 40, '2021-06-20 19:19:33', 97, '10000.00', 19),
(232, 41, '2021-06-20 19:19:33', 100, '6000.00', 19),
(233, 42, '2021-06-20 19:19:33', 100, '6000.00', 19),
(234, 43, '2021-06-20 19:19:33', 100, '6000.00', 19),
(235, 44, '2021-06-20 19:19:33', 100, '30000.00', 19),
(236, 45, '2021-06-20 19:19:33', 100, '32000.00', 19),
(237, 46, '2021-06-20 19:19:33', 96, '35000.00', 19),
(238, 47, '2021-06-20 19:19:33', 98, '37000.00', 19),
(239, 48, '2021-06-20 19:19:33', 100, '37000.00', 19),
(240, 49, '2021-06-20 19:19:33', 196, '35000.00', 19),
(241, 50, '2021-06-20 19:19:33', 100, '32000.00', 19),
(242, 51, '2021-06-20 19:19:33', 98, '35000.00', 19),
(243, 52, '2021-06-20 19:19:33', 100, '37000.00', 19),
(244, 53, '2021-06-20 19:19:33', 100, '35000.00', 19),
(245, 54, '2021-06-20 19:19:33', 100, '32000.00', 19),
(246, 55, '2021-06-20 19:19:33', 100, '37000.00', 19),
(247, 56, '2021-06-20 19:19:33', 99, '35000.00', 19),
(248, 57, '2021-06-20 19:19:33', 182, '12000.00', 19),
(249, 58, '2021-06-20 19:19:33', 100, '15000.00', 19),
(250, 59, '2021-06-20 19:19:33', 171, '15000.00', 19),
(251, 60, '2021-06-20 19:19:33', 84, '5000.00', 19),
(252, 61, '2021-06-20 19:19:33', 194, '15000.00', 19),
(253, 62, '2021-06-20 19:19:33', 98, '4000.00', 19),
(254, 63, '2021-06-20 19:19:33', 100, '6000.00', 19),
(255, 64, '2021-06-20 19:19:33', 98, '3000.00', 19),
(256, 65, '2021-06-20 19:19:33', 84, '7000.00', 19),
(257, 66, '2021-06-20 19:19:33', 198, '10000.00', 19),
(258, 67, '2021-06-20 19:19:33', 196, '5000.00', 19),
(259, 68, '2021-06-20 19:19:33', 195, '2000.00', 19),
(260, 69, '2021-06-20 19:19:33', 97, '6000.00', 19),
(261, 70, '2021-06-20 19:19:33', 99, '32000.00', 19),
(262, 71, '2021-06-20 19:19:33', 99, '20000.00', 19),
(263, 72, '2021-06-20 19:19:33', 91, '3000.00', 19),
(264, 73, '2021-06-20 19:19:33', 97, '10000.00', 19),
(265, 74, '2021-06-20 19:19:33', 196, '20000.00', 19),
(266, 76, '2021-06-20 20:07:39', 100, '420000.00', 19),
(267, 77, '2021-06-20 20:09:17', 100, '320000.00', 19);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `codproducto` int(11) NOT NULL,
  `descripcion` varchar(255) COLLATE utf8_spanish_ci NOT NULL,
  `proveedor` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `existencia` int(255) NOT NULL,
  `usuario_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`codproducto`, `descripcion`, `proveedor`, `precio`, `existencia`, `usuario_id`) VALUES
(1, 'Bife de chorizo', 11, '42000.00', 99, 19),
(2, 'Bife  de Lomo a la Plancha', 11, '35000.00', 93, 19),
(3, 'Bife a caballo', 11, '37000.00', 92, 19),
(4, 'Lomo a la pimienta', 11, '35000.00', 100, 19),
(5, 'Lomo al champignon', 11, '35000.00', 97, 19),
(6, 'Milanesa de carne', 11, '32000.00', 94, 19),
(7, 'Milanesa a la Napolitana de carne', 11, '35000.00', 98, 19),
(8, 'Pollo grille', 11, '30000.00', 98, 19),
(9, 'Pollo al champignon', 11, '32000.00', 100, 19),
(10, 'Milanesa de pollo', 11, '30000.00', 97, 19),
(11, 'Pollo al curry', 11, '30000.00', 100, 19),
(12, 'Pollo a la mostaza', 11, '32000.00', 99, 19),
(13, 'Strogonoff de pollo', 11, '32000.00', 100, 19),
(14, 'Cerdo al ajillo', 11, '32000.00', 94, 19),
(15, 'Cerdo a la mostaza', 11, '32000.00', 99, 19),
(16, 'Milanesa de Surubi', 11, '50000.00', 90, 19),
(17, 'Surubi Grille', 11, '55000.00', 100, 19),
(18, 'Surubi con salsa 4 queso', 11, '60000.00', 99, 19),
(19, 'Sopa de Pescado', 11, '30000.00', 96, 19),
(20, 'Hamburguesa el ancla', 11, '17000.00', 99, 19),
(21, 'Hamburguesa simple', 11, '8000.00', 100, 19),
(22, 'Hamburguesa completa', 11, '12000.00', 93, 19),
(23, 'Hamburguesa mixta', 11, '10000.00', 99, 19),
(24, 'Hamburguesa a la Parrilla', 11, '25000.00', 100, 19),
(25, 'Picada el Ancla', 11, '50000.00', 94, 19),
(26, 'Picada de jamón/queso', 11, '20000.00', 100, 19),
(27, 'Chipa guazu', 11, '10000.00', 98, 19),
(28, 'Sopa Paraguaya', 11, '10000.00', 100, 19),
(29, 'Papas fritas', 11, '10000.00', 97, 19),
(30, 'Papas fritas Noisette', 11, '12000.00', 99, 19),
(31, 'Romanita de surubi', 11, '40000.00', 98, 19),
(32, 'Empanada', 11, '3000.00', 85, 19),
(33, 'Empanada chilena', 11, '6000.00', 100, 19),
(34, 'Lomito Ancla', 11, '20000.00', 91, 19),
(35, 'Lomito completo', 11, '15000.00', 93, 19),
(36, 'Lomito Simple', 11, '12000.00', 95, 19),
(37, 'Lomito  Mixto', 11, '13000.00', 100, 19),
(38, 'Milanesa de Carne C.', 11, '17000.00', 100, 19),
(39, 'Milanesa de Carne S.', 11, '15000.00', 100, 19),
(40, 'Mixto Caliente a la Pizza', 11, '10000.00', 97, 19),
(41, 'Mixto Caliente', 11, '6000.00', 100, 19),
(42, 'Sandwi de jamon/queso', 11, '6000.00', 100, 19),
(43, 'Sandwi de Verdura', 11, '6000.00', 100, 19),
(44, 'Pizza Muzzarela', 11, '30000.00', 100, 19),
(45, 'Pizza de choclo', 11, '32000.00', 100, 19),
(46, 'Pizza de Calabresa/Peperoni', 11, '35000.00', 96, 19),
(47, 'Pizza Rockefort', 11, '37000.00', 98, 19),
(48, 'Pizza Jamon Tomate y Palmito', 11, '37000.00', 100, 19),
(49, 'Pizza Napolitana', 11, '35000.00', 196, 19),
(50, 'Pizza Jamón y Morrón', 11, '32000.00', 100, 19),
(51, 'Pizza de Pollo', 11, '35000.00', 98, 19),
(52, 'Pizza de atún', 11, '37000.00', 100, 19),
(53, 'Pizza Vegetariana', 11, '35000.00', 100, 19),
(54, 'Pizza Cebolla y Palmito', 11, '32000.00', 100, 19),
(55, 'Pizza Doble Muzzarela', 11, '37000.00', 100, 19),
(56, 'Pizza Primavera', 11, '35000.00', 98, 19),
(57, 'Menu del dia', 11, '12000.00', 182, 19),
(58, 'Menu+Delivery', 11, '15000.00', 100, 19),
(59, 'Miller 610 ml', 11, '15000.00', 171, 19),
(60, 'Gaseosa 500 ml', 11, '5000.00', 84, 19),
(61, 'Heineken 610 ml', 11, '15000.00', 194, 19),
(62, 'Soda 500 ml', 11, '4000.00', 98, 19),
(63, 'Agua 2 ltro', 11, '6000.00', 100, 19),
(64, 'Agua 500 ml', 11, '3000.00', 98, 19),
(65, 'Gaseosa 1 ltro', 11, '7000.00', 83, 19),
(66, 'Hielo Grande', 11, '10000.00', 198, 19),
(67, 'Hielo Mediano', 11, '5000.00', 196, 19),
(68, 'Hielo Pequeño', 11, '2000.00', 195, 19),
(69, 'Ensalada mixta', 11, '6000.00', 97, 19),
(70, 'Bife de carne', 11, '32000.00', 99, 19),
(71, 'Bife solo', 11, '20000.00', 99, 19),
(72, 'Vaso de jugo', 11, '3000.00', 91, 19),
(73, 'Caipiriña', 11, '10000.00', 97, 19),
(74, 'Mbeju', 11, '20000.00', 196, 19),
(75, 'cocas', 11, '15000.00', 10, 19),
(76, 'bife   acaballo', 12, '420000.00', 100, 19),
(77, 'sopa de verdura', 11, '320000.00', 100, 19);

--
-- Disparadores `producto`
--
DELIMITER $$
CREATE TRIGGER `Entrada_Producto` AFTER INSERT ON `producto` FOR EACH ROW BEGIN
    	INSERT INTO entrada(codproducto,cantidad,precio,usuario_id)
    	VALUES (new.codproducto,new.existencia,new.precio,new.usuario_id);
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

CREATE TABLE `proveedor` (
  `codproveedor` int(11) NOT NULL,
  `proveedor` varchar(255) COLLATE utf8_spanish_ci NOT NULL,
  `contacto` varchar(255) COLLATE utf8_spanish_ci NOT NULL,
  `celular` int(255) NOT NULL,
  `direccion` varchar(255) COLLATE utf8_spanish_ci NOT NULL,
  `usuario_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `proveedor`
--

INSERT INTO `proveedor` (`codproveedor`, `proveedor`, `contacto`, `celular`, `direccion`, `usuario_id`) VALUES
(11, 'coca cola', '097854', 978545, 'centro', 19),
(12, 'jose miguel', '5258645', 97852335, 'centro', 19);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `idrol` int(11) NOT NULL,
  `rol` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`idrol`, `rol`) VALUES
(5, 'Administrador');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ticket`
--

CREATE TABLE `ticket` (
  `noticket` bigint(11) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `usuario` int(11) NOT NULL,
  `codcliente` int(11) NOT NULL,
  `totalticket` decimal(10,2) NOT NULL,
  `estado` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `ticket`
--

INSERT INTO `ticket` (`noticket`, `fecha`, `usuario`, `codcliente`, `totalticket`, `estado`) VALUES
(95, '2021-06-05 11:43:00', 19, 9, '15000.00', 1),
(96, '2021-06-05 11:43:56', 19, 9, '30000.00', 1),
(97, '2021-06-19 23:17:32', 19, 9, '15000.00', 1),
(98, '2021-06-20 19:09:05', 19, 9, '15000.00', 1),
(99, '2021-06-20 19:19:56', 19, 9, '7000.00', 1),
(100, '2021-06-20 20:03:50', 19, 9, '67000.00', 1),
(101, '2021-06-29 22:22:03', 19, 9, '80000.00', 1),
(102, '2021-06-29 22:26:10', 19, 9, '112000.00', 1),
(103, '2021-06-30 17:12:01', 19, 9, '81000.00', 1),
(104, '2021-07-23 19:48:32', 19, 9, '35000.00', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `idusuario` int(11) NOT NULL,
  `nombre` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `correo` varchar(255) COLLATE utf8_spanish_ci NOT NULL,
  `usuario` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `clave` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `rol` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`idusuario`, `nombre`, `correo`, `usuario`, `clave`, `rol`) VALUES
(19, 'ancla', 'ancla@gmail.com', 'admin', '827ccb0eea8a706c4c34a16891f84e7b', 5);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`idcliente`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `detalleticket`
--
ALTER TABLE `detalleticket`
  ADD PRIMARY KEY (`correlativo`),
  ADD KEY `noticket` (`noticket`),
  ADD KEY `codproducto` (`codproducto`);

--
-- Indices de la tabla `detalle_temp`
--
ALTER TABLE `detalle_temp`
  ADD PRIMARY KEY (`correlativo`),
  ADD KEY `codproducto` (`codproducto`);

--
-- Indices de la tabla `entrada`
--
ALTER TABLE `entrada`
  ADD PRIMARY KEY (`correlativo`),
  ADD KEY `codproducto` (`codproducto`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`codproducto`),
  ADD KEY `proveedor` (`proveedor`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`codproveedor`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`idrol`);

--
-- Indices de la tabla `ticket`
--
ALTER TABLE `ticket`
  ADD PRIMARY KEY (`noticket`),
  ADD KEY `codcliente` (`codcliente`),
  ADD KEY `usuario` (`usuario`),
  ADD KEY `estado` (`estado`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idusuario`),
  ADD KEY `rol` (`rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `idcliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `detalleticket`
--
ALTER TABLE `detalleticket`
  MODIFY `correlativo` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=158;

--
-- AUTO_INCREMENT de la tabla `detalle_temp`
--
ALTER TABLE `detalle_temp`
  MODIFY `correlativo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=367;

--
-- AUTO_INCREMENT de la tabla `entrada`
--
ALTER TABLE `entrada`
  MODIFY `correlativo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=268;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `codproducto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  MODIFY `codproveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `idrol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `ticket`
--
ALTER TABLE `ticket`
  MODIFY `noticket` bigint(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=105;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`idusuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detalleticket`
--
ALTER TABLE `detalleticket`
  ADD CONSTRAINT `detalleticket_ibfk_5` FOREIGN KEY (`noticket`) REFERENCES `ticket` (`noticket`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detalleticket_ibfk_6` FOREIGN KEY (`codproducto`) REFERENCES `producto` (`codproducto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detalle_temp`
--
ALTER TABLE `detalle_temp`
  ADD CONSTRAINT `detalle_temp_ibfk_1` FOREIGN KEY (`codproducto`) REFERENCES `producto` (`codproducto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `entrada`
--
ALTER TABLE `entrada`
  ADD CONSTRAINT `entrada_ibfk_1` FOREIGN KEY (`codproducto`) REFERENCES `producto` (`codproducto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `producto_ibfk_1` FOREIGN KEY (`proveedor`) REFERENCES `proveedor` (`codproveedor`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `producto_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`idusuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD CONSTRAINT `proveedor_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`idusuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ticket`
--
ALTER TABLE `ticket`
  ADD CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`codcliente`) REFERENCES `cliente` (`idcliente`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ticket_ibfk_2` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`idusuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`rol`) REFERENCES `rol` (`idrol`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
