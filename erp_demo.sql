-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 23-09-2025 a las 15:35:37
-- Versión del servidor: 8.3.0
-- Versión de PHP: 8.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `erp_demo`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `articulos`
--

DROP TABLE IF EXISTS `articulos`;
CREATE TABLE IF NOT EXISTS `articulos` (
  `id_articulo` int NOT NULL AUTO_INCREMENT,
  `sku` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `nombre` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_general_ci,
  `categoria` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `precio_compra` decimal(12,2) NOT NULL,
  `precio_venta` decimal(12,2) NOT NULL,
  `stock` int DEFAULT '0',
  `stock_minimo` int DEFAULT '0',
  `politica_operacion` text COLLATE utf8mb4_general_ci,
  `parametros_operacion` text COLLATE utf8mb4_general_ci,
  `proveedor` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ubicacion` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fecha_alta` date NOT NULL DEFAULT (curdate()),
  `id_usuario` int DEFAULT NULL,
  `estado` enum('activo','inactivo') COLLATE utf8mb4_general_ci DEFAULT 'activo',
  PRIMARY KEY (`id_articulo`),
  UNIQUE KEY `sku` (`sku`),
  KEY `id_usuario` (`id_usuario`),
  KEY `idx_articulo_categoria` (`categoria`),
  KEY `idx_articulo_estado` (`estado`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

DROP TABLE IF EXISTS `clientes`;
CREATE TABLE IF NOT EXISTS `clientes` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `nombre_razon_social` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `dni_cuit` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `telefono` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `direccion` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo_cliente` enum('mayorista','minorista','otros') COLLATE utf8mb4_general_ci DEFAULT 'minorista',
  `tipo_facturacion` enum('Responsable Inscripto','Consumidor Final','Exento','Monotributista','Otros') COLLATE utf8mb4_general_ci DEFAULT 'Consumidor Final',
  `fecha_alta` date NOT NULL DEFAULT (curdate()),
  `estado` enum('activo','inactivo') COLLATE utf8mb4_general_ci DEFAULT 'activo',
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `dni_cuit` (`dni_cuit`),
  KEY `idx_cliente_tipo` (`tipo_cliente`),
  KEY `idx_cliente_estado` (`estado`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_ventas`
--

DROP TABLE IF EXISTS `detalle_ventas`;
CREATE TABLE IF NOT EXISTS `detalle_ventas` (
  `id_detalle` int NOT NULL AUTO_INCREMENT,
  `id_venta` int NOT NULL,
  `id_articulo` int NOT NULL,
  `cantidad` int NOT NULL,
  `precio_unitario` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) GENERATED ALWAYS AS ((`cantidad` * `precio_unitario`)) STORED,
  PRIMARY KEY (`id_detalle`),
  KEY `id_venta` (`id_venta`),
  KEY `id_articulo` (`id_articulo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `stock_movimientos`
--

DROP TABLE IF EXISTS `stock_movimientos`;
CREATE TABLE IF NOT EXISTS `stock_movimientos` (
  `id_movimiento` int NOT NULL AUTO_INCREMENT,
  `id_articulo` int NOT NULL,
  `tipo` enum('entrada','salida','ajuste') COLLATE utf8mb4_general_ci NOT NULL,
  `cantidad` int NOT NULL,
  `referencia` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `parametros_operacion` text COLLATE utf8mb4_general_ci,
  `fecha_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_movimiento`),
  KEY `id_articulo` (`id_articulo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nombre_apellido` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `usuario_login` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `rol` enum('administrador','vendedor','deposito','otros') COLLATE utf8mb4_general_ci DEFAULT 'vendedor',
  `permisos` text COLLATE utf8mb4_general_ci,
  `estado` enum('activo','inactivo') COLLATE utf8mb4_general_ci DEFAULT 'activo',
  `ultimo_acceso` datetime DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `usuario_login` (`usuario_login`),
  KEY `idx_usuario_estado` (`estado`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios_auditoria`
--

DROP TABLE IF EXISTS `usuarios_auditoria`;
CREATE TABLE IF NOT EXISTS `usuarios_auditoria` (
  `id_auditoria` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `accion` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `fecha_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_auditoria`),
  KEY `id_usuario` (`id_usuario`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

DROP TABLE IF EXISTS `ventas`;
CREATE TABLE IF NOT EXISTS `ventas` (
  `id_venta` int NOT NULL AUTO_INCREMENT,
  `fecha_hora` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_cliente` int NOT NULL,
  `id_usuario` int NOT NULL,
  `total` decimal(12,2) NOT NULL,
  `forma_pago` enum('efectivo','tarjeta','transferencia','otros') COLLATE utf8mb4_general_ci DEFAULT 'efectivo',
  `estado` enum('pendiente','completada','cancelada') COLLATE utf8mb4_general_ci DEFAULT 'pendiente',
  `documento` enum('factura','ticket','nota_credito','otros') COLLATE utf8mb4_general_ci DEFAULT 'ticket',
  `ubicacion_entrega` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_venta`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_usuario` (`id_usuario`),
  KEY `idx_venta_estado` (`estado`),
  KEY `idx_venta_fecha` (`fecha_hora`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
