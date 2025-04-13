DROP DATABASE IF EXIST ProyectoFinal;
CREATE DATABASE ProyectoFinal;
USE ProyectoFinal;

 
CREATE TABLE clientes (
    id_Cliente BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100) NOT NULL,
    edad INT NOT NULL CHECK(edad >= 18),
    sexo CHAR(1) NOT NULL CHECK (sexo IN ('M','F','O')),
    numero VARCHAR(12) UNIQUE NOT NULL,
    correo_electronico VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(20) NOT NULL, 
    direccion VARCHAR(200) NOT NULL
);

CREATE TABLE estado_pedido (
    id_estado_pedido BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(200) NOT NULL
);

CREATE TABLE sucursal (
    id_Sucursal BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    direccion TEXT NOT NULL,
    telefono VARCHAR(15) NOT NULL
);

CREATE TABLE roles (
    id_Rol BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE usuarios (
    id_Usuario BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    correo VARCHAR(255) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
    id_Rol BIGINT NOT NULL,
    FOREIGN KEY (id_Rol) REFERENCES roles(id_Rol) ON DELETE CASCADE
);

CREATE TABLE estado_producto (
    id_Estado BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(100) NOT NULL
);

CREATE TABLE marca (
    id_Marca BIGINT PRIMARY KEY AUTO_INCREMENT,
    marca VARCHAR(100) NOT NULL
);

CREATE TABLE categoria (
    id_Categoria BIGINT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(100) NOT NULL
);

CREATE TABLE productos (
    id_Producto BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_Categoria BIGINT NOT NULL,
    id_Marca BIGINT NOT NULL,
    id_Estado BIGINT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    modelo VARCHAR(100),
    precio DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_Categoria) REFERENCES categoria(id_Categoria) ON DELETE CASCADE,
    FOREIGN KEY (id_Marca) REFERENCES marca(id_Marca) ON DELETE CASCADE,
    FOREIGN KEY (id_Estado) REFERENCES estado_producto(id_Estado) ON DELETE CASCADE
);

CREATE TABLE fotos_producto (
    id_Foto BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_Producto BIGINT NOT NULL,
    urlFoto VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_Producto) REFERENCES productos(id_Producto) ON DELETE CASCADE
);

CREATE TABLE inventario (
    id_Inventario BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_Producto BIGINT NOT NULL,
    id_Sucursal BIGINT NOT NULL,
    stockActual INT NOT NULL,
    stockMinimo INT NOT NULL,
    fechaRegistro DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_Producto) REFERENCES productos(id_Producto) ON DELETE CASCADE,
    FOREIGN KEY (id_Sucursal) REFERENCES sucursal(id_Sucursal) ON DELETE CASCADE
);

CREATE TABLE movimientos_stock (
    id_Movimiento BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_Producto BIGINT NOT NULL,
    id_Sucursal BIGINT NOT NULL,
    tipoMovimiento ENUM('entrada', 'salida') NOT NULL,
    cantidad INT NOT NULL,
    fechaMovimiento DATETIME DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(255),
    FOREIGN KEY (id_Producto) REFERENCES productos(id_Producto) ON DELETE CASCADE,
    FOREIGN KEY (id_Sucursal) REFERENCES sucursal(id_Sucursal) ON DELETE CASCADE
);

CREATE TABLE pedidos (
    id_Pedido BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_Cliente BIGINT NOT NULL,
    id_estado_pedido BIGINT NOT NULL,
    totalCompra DECIMAL(10,2) NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_Cliente) REFERENCES clientes(id_Cliente) ON DELETE CASCADE,
    FOREIGN KEY (id_estado_pedido) REFERENCES estado_pedido(id_estado_pedido) ON DELETE CASCADE
);

CREATE TABLE detalle_pedido (
    id_Detalle BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_Pedido BIGINT NOT NULL,
    id_Producto BIGINT NOT NULL,
    cantidad INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_Pedido) REFERENCES pedidos(id_Pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_Producto) REFERENCES productos(id_Producto) ON DELETE CASCADE
);

CREATE TABLE pagos (
    id_Pago BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_Pedido BIGINT NOT NULL,
    fecha_pago DATETIME NOT NULL,
    metodo_pago VARCHAR(50) NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_Pedido) REFERENCES pedidos(id_Pedido) ON DELETE CASCADE
);

CREATE TABLE envios (
    id_Envio BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_Pedido BIGINT NOT NULL,
    direccion_Envio VARCHAR(255) NOT NULL,
    empresa_Recolectora VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_Pedido) REFERENCES pedidos(id_Pedido) ON DELETE CASCADE
);

CREATE TABLE carritos (
    id_carrito BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_cliente BIGINT NOT NULL,
    total_carrito DOUBLE NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE
);

CREATE TABLE productos_carrito (
    id_producto_carrito BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_carrito BIGINT NOT NULL,
    id_producto BIGINT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DOUBLE NOT NULL,
    FOREIGN KEY (id_carrito) REFERENCES carritos(id_carrito) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE
);


CREATE TABLE carrito (
    id_carrito BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_cliente BIGINT UNIQUE, -- solo un carrito por cliente
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE item_carrito (
    id_item BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_carrito BIGINT NOT NULL,
    id_producto BIGINT NOT NULL,
    cantidad INT NOT NULL ,
    FOREIGN KEY (id_carrito) REFERENCES carrito(id_carrito),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    UNIQUE (id_carrito, id_producto) -- evita duplicar el mismo producto
);

ALTER TABLE pedidos CHANGE COLUMN totalCompra total_compra DECIMAL(10,2) NOT NULL;
ALTER TABLE inventario CHANGE COLUMN fecha_registro fecha_registro  DATE NOT NULL;
ALTER TABLE inventario CHANGE COLUMN stockActual stock_actual INT NOT NULL;
ALTER TABLE inventario CHANGE COLUMN stockMinimo stock_minimo INT NOT NULL;


INSERT INTO Clientes (nombre, apellido_paterno, apellido_materno, edad, sexo, numero, correo_electronico, contrasena, direccion) 
VALUES ('Juan', 'García', 'Pérez', 30, 'M', '5551234567', 'juan.perez@example.com', 'clave123', 'Calle 123, CDMX'),
('Ana', 'López', 'Martínez', 25, 'F', '5557654321', 'ana.lopez@example.com', 'segura456', 'Avenida Siempre Viva 742, GDL'),
 ('Carlos', 'Fernández', 'Ruiz', 40, 'M', '5559876543', 'carlos.ruiz@example.com', 'password789', 'Calle Reforma 345, MTY');

INSERT INTO estado_pedido (descripcion) VALUES 
('Pendiente'),
('En camino'),
('Entregado');


INSERT INTO pedidos (id_Cliente, id_estado_pedido, totalCompra,fecha) VALUES 
(1, 1, 1500.00,  NOW()),
(5, 2, 2800.50,  NOW()),
(6, 3, 3500.75,  NOW());

INSERT INTO envios (id_Envio,id_Pedido, direccion_Envio, empresa_Recolectora) VALUES 
(13, 'Calle 123, Ciudad A', 'DHL'),
(14, 'Avenida 456, Ciudad B', 'FedEx'),
(15, 'Boulevard 789, Ciudad C', 'UPS');


INSERT INTO pagos (id_Pedido, fecha_pago, metodo_pago, monto) VALUES 
(13, NOW(), 'Tarjeta de Crédito', 1500.00),
(14, NOW(), 'PayPal', 2800.50),
(15, NOW(), 'Transferencia Bancaria', 3500.75);

INSERT INTO categoria (tipo) VALUES 
('Electrónica'),
('Ropa'),
('Hogar');

INSERT INTO marca (marca) VALUES 
('Samsung'),
('Apple'),
('Sony');

INSERT INTO estado_producto (descripcion) VALUES 
('Disponible'),
('Agotado'),
('En espera');

INSERT INTO productos (id_Categoria, id_Marca, id_Estado, nombre, descripcion, modelo, precio) VALUES
(1, 1, 1, 'Laptop Dell XPS', 'Laptop de alto rendimiento', 'XPS 15', 18999.99),
(2, 2, 1, 'Mouse Logitech', 'Mouse inalámbrico ergonómico', 'MX Master 3', 1499.50),
(2, 3, 1, 'Teclado Mecánico Razer', 'Teclado RGB para gaming', 'BlackWidow', 3299.00),
(3, 3, 1, 'Monitor Samsung', 'Monitor 24 pulgadas Full HD', 'S24F350', 2999.99),
(1, 2, 1, 'Disco SSD Kingston', 'SSD de 1TB NVMe', 'A2000', 1899.00),
(1, 1, 1, 'Memoria RAM Corsair', 'RAM DDR4 16GB', 'Vengeance LPX', 1599.99),
(3, 4, 1, 'Silla Gamer Cougar', 'Silla ergonómica para gamers', 'Armor One', 4999.00),
(1, 2, 1, 'Procesador Intel i7', 'Intel Core i7 12700K', '12700K', 9999.99),
(1, 2, 1, 'Tarjeta Gráfica RTX 3060', 'NVIDIA GeForce RTX 3060', 'RTX 3060', 13999.00),
(1, 2, 1, 'Fuente de Poder EVGA', '750W 80 Plus Gold', 'SuperNOVA 750', 2899.00),
(1, 1, 1, 'Laptop HP Pavilion', 'Laptop ligera con Intel Core i5', 'Pavilion 14', 15999.99),
(1, 2, 1, 'Mouse Microsoft', 'Mouse óptico con cable', 'Comfort 4500', 499.99),
(1, 3, 1, 'Teclado Logitech', 'Teclado mecánico inalámbrico', 'G915', 5499.00),
(1, 2, 1, 'Monitor LG UltraWide', 'Monitor 34 pulgadas UltraWide', '34WN750', 9999.99),
(1, 3, 1, 'Disco HDD Seagate', 'Disco duro 2TB', 'Barracuda', 1599.00),
(1, 2, 1, 'Memoria RAM Kingston', 'RAM DDR4 8GB', 'Fury Beast', 899.99),
(3, 2, 1, 'Silla Ejecutiva Herman Miller', 'Silla ergonómica de oficina', 'Aeron', 19999.00),
(1, 1, 1, 'Procesador AMD Ryzen 7', 'AMD Ryzen 7 5800X', '5800X', 8499.99),
(1, 2, 1, 'Tarjeta Gráfica RTX 3080', 'NVIDIA GeForce RTX 3080', 'RTX 3080', 20999.00),
(1, 1, 1, 'Fuente de Poder Corsair', '850W 80 Plus Platinum', 'HX850', 3999.00);


INSERT INTO detalle_pedido (id_Pedido, id_Producto, cantidad, subtotal) VALUES 
(13, 1, 2, 500.00),
(14, 2, 1, 1800.50),
(15, 3, 3, 2500.75);

INSERT INTO sucursal (nombre, direccion, telefono) VALUES 
('Sucursal Centro', 'Avenida Principal 123, Ciudad X', '555-1234'),
('Sucursal Norte', 'Calle Secundaria 456, Ciudad Y', '555-5678'),
('Sucursal Sur', 'Plaza Comercial 789, Ciudad Z', '555-9012');

INSERT INTO inventario (id_Producto, id_Sucursal, stockActual, stockMinimo, fechaRegistro) VALUES 
(16, 1, 10, 2, NOW()),
(17, 2, 5, 1, NOW()),
(18, 3, 20, 5, NOW());







INSERT INTO marca (id_Marca, marca) VALUES
(11, 'Dell'),
(12, 'Logitech'),
(13, 'Razer'),
(4, 'Samsung'),
(5, 'Kingston'),
(6, 'Corsair'),
(7, 'Cougar'),
(8, 'Intel'),
(9, 'NVIDIA'),
(10, 'EVGA');


INSERT INTO productos (id_Categoria, id_Marca, id_Estado, nombre, descripcion, modelo, precio) VALUES
(2, 3, 1, 'Laptop Dell XPS', 'Laptop de alto rendimiento', 'XPS 15', 18999.99)

SELECT* FROM estado_producto;
 
SELECT * FROM marca;

SELECT * FROM categoria;

SELECT * FROM clientes;

SELECT * FROM pedidos;

SELECT * FROM productos;

SELECT * FROM detalle_pedido;

USE proyectofinal;

SELECT * FROM inventario;

SELECT * FROM sucursal;

SELECT * FROM envios;marca

SELECT * FROM estado_pedido;

SELECT * FROM fotos_producto;

DESC fotos_producto;