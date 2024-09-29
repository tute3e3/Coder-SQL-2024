-- SCRIPT DDLs "Consultora Big Data"

-- Creacion BD
CREATE DATABASE bigdata;
USE bigdata;
-------------------------
---- Creacion Tablas ----
CREATE TABLE empresa (
    idEmpresa int PRIMARY KEY,
    nombre varchar(50),
    pais varchar(50),
    area varchar(50)
);

CREATE TABLE cliente (
    idCliente int PRIMARY KEY,
    nombre varchar(50),
    email varchar(50),
    empresa int,
    FOREIGN KEY (empresa) REFERENCES empresa(idEmpresa)
);

CREATE TABLE tecnologia (
    idTecnologia int PRIMARY KEY,
    nombre varchar(50)
);

CREATE TABLE servicio (
    idServicio int PRIMARY KEY,
    descripcion varchar(100),
    tecnologia int,
    cliente int,
    FOREIGN KEY (tecnologia) REFERENCES tecnologia(idTecnologia),
    FOREIGN KEY (cliente) REFERENCES cliente(idCliente)
);

CREATE TABLE facturacion (
    idFacturacion int PRIMARY KEY,
    monto decimal(10,2),
    descripcion varchar(100),
    fecha date
);

CREATE TABLE roles (
    idRol int PRIMARY KEY,
    nombre varchar(50),
    descripcion varchar(100)
);

CREATE TABLE empleado (
    idEmpleado int PRIMARY KEY,
    nombre varchar(50),
    email varchar(50),
    edad decimal(2,0),
    rol int,
    FOREIGN KEY (rol) REFERENCES roles(idRol)
);

CREATE TABLE tarea (
    idTarea int PRIMARY KEY,
    descripcion varchar(100),
    fecha date,
    rol int,
    empleado int,
    FOREIGN KEY (rol) REFERENCES roles(idRol),
    FOREIGN KEY (empleado) REFERENCES empleado(idEmpleado)
);

CREATE TABLE proyecto (
    idProyecto int PRIMARY KEY,
    nombre varchar(50),
    descripcion varchar(100),
    horasTotales int,
    servicio int,
    empleado int,
    FOREIGN KEY (horasTotales) REFERENCES facturacion(idFacturacion),
    FOREIGN KEY (servicio) REFERENCES servicio(idServicio),
    FOREIGN KEY (empleado) REFERENCES empleado(idEmpleado)
);

CREATE TABLE servicio_proyecto (
    id int PRIMARY KEY,
    idServicio int,
    idProyecto int,
    FOREIGN KEY (idServicio) REFERENCES servicio(idServicio),
    FOREIGN KEY (idProyecto) REFERENCES proyecto(idProyecto)
);
