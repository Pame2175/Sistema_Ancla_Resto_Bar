-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 01-06-2021 a las 21:07:20
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
(5, 8293845, 'Juan', 'Encarnacion', 994178761, 1);

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
(138, 92, 55, 2, '37000.00'),
(139, 93, 35, 1, '15000.00');

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
(76, 1, '2021-06-01 14:57:45', 99, '42000.00', 1),
(77, 2, '2021-06-01 14:57:45', 95, '35000.00', 1),
(78, 3, '2021-06-01 14:57:45', 93, '37000.00', 1),
(79, 4, '2021-06-01 14:57:45', 100, '35000.00', 1),
(80, 5, '2021-06-01 14:57:45', 98, '35000.00', 1),
(81, 6, '2021-06-01 14:57:45', 94, '32000.00', 1),
(82, 7, '2021-06-01 14:57:45', 98, '35000.00', 1),
(83, 8, '2021-06-01 14:57:45', 99, '30000.00', 1),
(84, 9, '2021-06-01 14:57:45', 100, '32000.00', 1),
(85, 10, '2021-06-01 14:57:45', 97, '30000.00', 1),
(86, 11, '2021-06-01 14:57:45', 100, '30000.00', 1),
(87, 12, '2021-06-01 14:57:45', 100, '32000.00', 1),
(88, 13, '2021-06-01 14:57:45', 100, '32000.00', 1),
(89, 14, '2021-06-01 14:57:45', 96, '32000.00', 1),
(90, 15, '2021-06-01 14:57:45', 99, '32000.00', 1),
(91, 16, '2021-06-01 14:57:45', 90, '50000.00', 1),
(92, 17, '2021-06-01 14:57:45', 100, '55000.00', 1),
(93, 18, '2021-06-01 14:57:45', 99, '60000.00', 1),
(94, 19, '2021-06-01 14:57:45', 96, '30000.00', 1),
(95, 20, '2021-06-01 14:57:45', 99, '17000.00', 1),
(96, 21, '2021-06-01 14:57:45', 100, '8000.00', 1),
(97, 22, '2021-06-01 14:57:45', 93, '12000.00', 1),
(98, 23, '2021-06-01 14:57:45', 100, '10000.00', 1),
(99, 24, '2021-06-01 14:57:45', 100, '25000.00', 1),
(100, 25, '2021-06-01 14:57:45', 95, '50000.00', 1),
(101, 26, '2021-06-01 14:57:45', 100, '20000.00', 1),
(102, 27, '2021-06-01 14:57:45', 98, '10000.00', 1),
(103, 28, '2021-06-01 14:57:45', 100, '10000.00', 1),
(104, 29, '2021-06-01 14:57:45', 97, '10000.00', 1),
(105, 30, '2021-06-01 14:57:45', 99, '12000.00', 1),
(106, 31, '2021-06-01 14:57:45', 98, '40000.00', 1),
(107, 32, '2021-06-01 14:57:45', 85, '3000.00', 1),
(108, 33, '2021-06-01 14:57:45', 100, '6000.00', 1),
(109, 34, '2021-06-01 14:57:45', 91, '20000.00', 1),
(110, 35, '2021-06-01 14:57:45', 93, '15000.00', 1),
(111, 36, '2021-06-01 14:57:45', 96, '12000.00', 1),
(112, 37, '2021-06-01 14:57:45', 100, '13000.00', 1),
(113, 38, '2021-06-01 14:57:45', 100, '17000.00', 1),
(114, 39, '2021-06-01 14:57:45', 100, '15000.00', 1),
(115, 40, '2021-06-01 14:57:45', 97, '10000.00', 1),
(116, 41, '2021-06-01 14:57:45', 100, '6000.00', 1),
(117, 42, '2021-06-01 14:57:45', 100, '6000.00', 1),
(118, 43, '2021-06-01 14:57:45', 100, '6000.00', 1),
(119, 44, '2021-06-01 14:57:45', 100, '30000.00', 1),
(120, 45, '2021-06-01 14:57:45', 100, '32000.00', 1),
(121, 46, '2021-06-01 14:57:45', 96, '35000.00', 1),
(122, 47, '2021-06-01 14:57:45', 98, '37000.00', 1),
(123, 48, '2021-06-01 14:57:45', 100, '37000.00', 1),
(124, 49, '2021-06-01 14:57:45', 196, '35000.00', 1),
(125, 50, '2021-06-01 14:57:45', 100, '32000.00', 1),
(126, 51, '2021-06-01 14:57:45', 98, '35000.00', 1),
(127, 52, '2021-06-01 14:57:45', 100, '37000.00', 1),
(128, 53, '2021-06-01 14:57:45', 100, '35000.00', 1),
(129, 54, '2021-06-01 14:57:45', 100, '32000.00', 1),
(130, 55, '2021-06-01 14:57:45', 100, '37000.00', 1),
(131, 56, '2021-06-01 14:57:45', 99, '35000.00', 1),
(132, 57, '2021-06-01 14:57:45', 182, '12000.00', 1),
(133, 58, '2021-06-01 14:57:45', 100, '15000.00', 1),
(134, 59, '2021-06-01 14:57:45', 171, '15000.00', 1),
(135, 60, '2021-06-01 14:57:45', 84, '5000.00', 1),
(136, 61, '2021-06-01 14:57:45', 194, '15000.00', 1),
(137, 62, '2021-06-01 14:57:45', 98, '4000.00', 1),
(138, 63, '2021-06-01 14:57:45', 100, '6000.00', 1),
(139, 64, '2021-06-01 14:57:45', 98, '3000.00', 1),
(140, 65, '2021-06-01 14:57:45', 84, '7000.00', 1),
(141, 66, '2021-06-01 14:57:45', 198, '10000.00', 1),
(142, 67, '2021-06-01 14:57:45', 196, '5000.00', 1),
(143, 68, '2021-06-01 14:57:45', 195, '2000.00', 1),
(144, 69, '2021-06-01 14:57:45', 97, '6000.00', 1),
(145, 70, '2021-06-01 14:57:45', 99, '32000.00', 1),
(146, 71, '2021-06-01 14:57:45', 99, '20000.00', 1),
(147, 72, '2021-06-01 14:57:45', 91, '3000.00', 1),
(148, 73, '2021-06-01 14:57:45', 97, '10000.00', 1),
(149, 74, '2021-06-01 14:57:45', 196, '20000.00', 1);

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
(1, 'Bife de chorizo', 5, '42000.00', 99, 1),
(2, 'Bife  de Lomo a la Plancha', 5, '35000.00', 95, 1),
(3, 'Bife a caballo', 5, '37000.00', 93, 1),
(4, 'Lomo a la pimienta', 5, '35000.00', 100, 1),
(5, 'Lomo al champignon', 5, '35000.00', 98, 1),
(6, 'Milanesa de carne', 5, '32000.00', 94, 1),
(7, 'Milanesa a la Napolitana de carne', 5, '35000.00', 98, 1),
(8, 'Pollo grille', 5, '30000.00', 99, 1),
(9, 'Pollo al champignon', 5, '32000.00', 100, 1),
(10, 'Milanesa de pollo', 5, '30000.00', 97, 1),
(11, 'Pollo al curry', 5, '30000.00', 100, 1),
(12, 'Pollo a la mostaza', 5, '32000.00', 100, 1),
(13, 'Strogonoff de pollo', 5, '32000.00', 100, 1),
(14, 'Cerdo al ajillo', 5, '32000.00', 96, 1),
(15, 'Cerdo a la mostaza', 5, '32000.00', 99, 1),
(16, 'Milanesa de Surubi', 5, '50000.00', 90, 1),
(17, 'Surubi Grille', 5, '55000.00', 100, 1),
(18, 'Surubi con salsa 4 queso', 5, '60000.00', 99, 1),
(19, 'Sopa de Pescado', 5, '30000.00', 96, 1),
(20, 'Hamburguesa el ancla', 5, '17000.00', 99, 1),
(21, 'Hamburguesa simple', 5, '8000.00', 100, 1),
(22, 'Hamburguesa completa', 5, '12000.00', 93, 1),
(23, 'Hamburguesa mixta', 5, '10000.00', 100, 1),
(24, 'Hamburguesa a la Parrilla', 5, '25000.00', 100, 1),
(25, 'Picada el Ancla', 5, '50000.00', 95, 1),
(26, 'Picada de jamón/queso', 5, '20000.00', 100, 1),
(27, 'Chipa guazu', 5, '10000.00', 98, 1),
(28, 'Sopa Paraguaya', 5, '10000.00', 100, 1),
(29, 'Papas fritas', 5, '10000.00', 97, 1),
(30, 'Papas fritas Noisette', 5, '12000.00', 99, 1),
(31, 'Romanita de surubi', 5, '40000.00', 98, 1),
(32, 'Empanada', 5, '3000.00', 85, 1),
(33, 'Empanada chilena', 5, '6000.00', 100, 1),
(34, 'Lomito Ancla', 5, '20000.00', 91, 1),
(35, 'Lomito completo', 5, '15000.00', 92, 1),
(36, 'Lomito Simple', 5, '12000.00', 96, 1),
(37, 'Lomito  Mixto', 5, '13000.00', 100, 1),
(38, 'Milanesa de Carne C.', 5, '17000.00', 100, 1),
(39, 'Milanesa de Carne S.', 5, '15000.00', 100, 1),
(40, 'Mixto Caliente a la Pizza', 5, '10000.00', 97, 1),
(41, 'Mixto Caliente', 5, '6000.00', 100, 1),
(42, 'Sandwi de jamon/queso', 5, '6000.00', 100, 1),
(43, 'Sandwi de Verdura', 5, '6000.00', 100, 1),
(44, 'Pizza Muzzarela', 5, '30000.00', 100, 1),
(45, 'Pizza de choclo', 5, '32000.00', 100, 1),
(46, 'Pizza de Calabresa/Peperoni', 5, '35000.00', 96, 1),
(47, 'Pizza Rockefort', 5, '37000.00', 98, 1),
(48, 'Pizza Jamon Tomate y Palmito', 5, '37000.00', 100, 1),
(49, 'Pizza Napolitana', 5, '35000.00', 196, 1),
(50, 'Pizza Jamón y Morrón', 5, '32000.00', 100, 1),
(51, 'Pizza de Pollo', 5, '35000.00', 98, 1),
(52, 'Pizza de atún', 5, '37000.00', 100, 1),
(53, 'Pizza Vegetariana', 5, '35000.00', 100, 1),
(54, 'Pizza Cebolla y Palmito', 5, '32000.00', 100, 1),
(55, 'Pizza Doble Muzzarela', 5, '37000.00', 98, 1),
(56, 'Pizza Primavera', 5, '35000.00', 99, 1),
(57, 'Menu del dia', 5, '12000.00', 182, 1),
(58, 'Menu+Delivery', 5, '15000.00', 100, 1),
(59, 'Miller 610 ml', 5, '15000.00', 171, 1),
(60, 'Gaseosa 500 ml', 5, '5000.00', 84, 1),
(61, 'Heineken 610 ml', 5, '15000.00', 194, 1),
(62, 'Soda 500 ml', 5, '4000.00', 98, 1),
(63, 'Agua 2 ltro', 5, '6000.00', 100, 1),
(64, 'Agua 500 ml', 5, '3000.00', 98, 1),
(65, 'Gaseosa 1 ltro', 5, '7000.00', 84, 1),
(66, 'Hielo Grande', 5, '10000.00', 198, 1),
(67, 'Hielo Mediano', 5, '5000.00', 196, 1),
(68, 'Hielo Pequeño', 5, '2000.00', 195, 1),
(69, 'Ensalada mixta', 5, '6000.00', 97, 1),
(70, 'Bife de carne', 5, '32000.00', 99, 1),
(71, 'Bife solo', 5, '20000.00', 99, 1),
(72, 'Vaso de jugo', 5, '3000.00', 91, 1),
(73, 'Caipiriña', 5, '10000.00', 97, 1),
(74, 'Mbeju', 5, '20000.00', 196, 1);

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
(2, 'Indega', '09985805660', 985746123, 'encarnacion', 1),
(5, 'Ancla', 'ancla@gmail.com', 985805660, 'Encarnacion', 1);

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
(92, '2021-06-01 15:03:29', 1, 5, '74000.00', 1),
(93, '2021-06-01 15:05:06', 1, 5, '15000.00', 1);

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
(1, 'ancla', 'ancla@gmail.com', 'admin', '827ccb0eea8a706c4c34a16891f84e7b', 5);

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
  MODIFY `idcliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `detalleticket`
--
ALTER TABLE `detalleticket`
  MODIFY `correlativo` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=140;

--
-- AUTO_INCREMENT de la tabla `detalle_temp`
--
ALTER TABLE `detalle_temp`
  MODIFY `correlativo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=344;

--
-- AUTO_INCREMENT de la tabla `entrada`
--
ALTER TABLE `entrada`
  MODIFY `correlativo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=150;

--
-- AUTO_INCREMENT de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  MODIFY `codproveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `idrol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `ticket`
--
ALTER TABLE `ticket`
  MODIFY `noticket` bigint(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=94;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

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
  ADD CONSTRAINT `detalleticket_ibfk_4` FOREIGN KEY (`codproducto`) REFERENCES `producto` (`codproducto`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detalleticket_ibfk_5` FOREIGN KEY (`noticket`) REFERENCES `ticket` (`noticket`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detalle_temp`
--
ALTER TABLE `detalle_temp`
  ADD CONSTRAINT `detalle_temp_ibfk_2` FOREIGN KEY (`codproducto`) REFERENCES `producto` (`codproducto`) ON DELETE CASCADE ON UPDATE CASCADE;

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
