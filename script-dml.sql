/*=========================================================
=                   INSERCIÓN DE DATOS                    =
=========================================================== */

-- Tabla "empresa"
INSERT INTO empresa (idEmpresa, nombre, pais, area) VALUES
(1, 'TechCorp', 'Estados Unidos', 'Tecnología'),
(2, 'DataAnalytics', 'Alemania', 'Consultoría'),
(3, 'InnovaData', 'España', 'Investigación'),
(4, 'BigSolutions', 'Brasil', 'Tecnología');

-- Tabla "cliente"
INSERT INTO cliente (idCliente, nombre, email, empresa) VALUES
(1, 'John Doe', 'johndoe@techcorp.com', 1),
(2, 'Jane Smith', 'janesmith@dataanalytics.de', 2),
(3, 'Carlos Pérez', 'cperez@innovadata.es', 3),
(4, 'Maria García', 'mgarcia@bigsolutions.br', 4);

-- Tabla "tecnologia"
INSERT INTO tecnologia (idTecnologia, nombre) VALUES
(1, 'Python'),
(2, 'SQL'),
(3, 'Big Data'),
(4, 'Machine Learning'),
(5, 'Cloud Computing');

-- Tabla "servicio"
INSERT INTO servicio (idServicio, descripcion, tecnologia, cliente) VALUES
(1, 'Desarrollo de pipeline de datos', 3, 1),
(2, 'Análisis de datos en la nube', 5, 2),
(3, 'Implementación de modelos predictivos', 4, 3),
(4, 'Consultoría en infraestructura Big Data', 3, 4),
(5, 'Optimización de bases de datos', 2, 1);

-- Tabla "facturacion"
INSERT INTO facturacion (id, monto, descripcion, fecha) VALUES
(1, 10000.00, 'Factura para desarrollo de pipeline de datos', '2024-01-15'),
(2, 15000.00, 'Factura para análisis de datos en la nube', '2024-02-20'),
(3, 12000.00, 'Factura para implementación de modelos predictivos', '2024-03-10'),
(4, 18000.00, 'Factura para consultoría en infraestructura Big Data', '2024-04-05'),
(5, 8000.00, 'Factura para optimización de bases de datos', '2024-05-18');

-- Tabla "empleado"
INSERT INTO empleado (idEmpleado, nombre, email, edad, rol) VALUES
(1, 'Alice Johnson', 'alice@techcorp.com', 30, 1),
(2, 'Bob Brown', 'bob@dataanalytics.de', 28, 2),
(3, 'Clara Martinez', 'clara@innovadata.es', 35, 3),
(4, 'Daniel Oliveira', 'daniel@bigsolutions.br', 32, 4),
(5, 'Eva Ruiz', 'eva@techcorp.com', 29, 1);

-- Tabla "roles"
INSERT INTO roles (idRol, nombre, descripcion) VALUES
(1, 'Data Engineer', 'Especialista en desarrollo de pipelines de datos'),
(2, 'Data Scientist', 'Especialista en análisis de datos y modelado'),
(3, 'Consultor Big Data', 'Consultor en soluciones de infraestructura Big Data'),
(4, 'Database Administrator', 'Administrador de bases de datos');

-- Tabla "proyecto"
INSERT INTO proyecto (idProyecto, nombre, descripcion, horasTotales, servicio, empleado) VALUES
(1, 'Pipeline Development', 'Desarrollo de pipeline de datos para TechCorp', 1, 1, 1),
(2, 'Cloud Data Analysis', 'Análisis de datos en la nube para DataAnalytics', 2, 2, 2),
(3, 'Predictive Modeling', 'Implementación de modelos predictivos para InnovaData', 3, 3, 3),
(4, 'Big Data Consulting', 'Consultoría en infraestructura Big Data para BigSolutions', 4, 4, 4),
(5, 'DB Optimization', 'Optimización de bases de datos para TechCorp', 5, 5, 1);

-- Tabla N:M "servicio_proyecto"
INSERT INTO servicio_proyecto (id, idServicio, idProyecto) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);

-- Tabla "tarea"
INSERT INTO tarea (idTarea, descripcion, fecha, rol, empleado) VALUES
(1, 'Configuración de infraestructura de datos', '2024-01-10', 1, 1),
(2, 'Análisis exploratorio de datos', '2024-02-15', 2, 2),
(3, 'Entrenamiento de modelos predictivos', '2024-03-05', 3, 3),
(4, 'Auditoría de infraestructura Big Data', '2024-04-01', 4, 4),
(5, 'Optimización de índices en bases de datos', '2024-05-10', 4, 5);


/*=========================================================
=                         VISTAS                          =
=========================================================== */

-- Vista "Resumen de proyectos activos"
CREATE VIEW proyectos_activos AS
SELECT 
    p.nombre AS NombreProyecto,
    p.descripcion AS DescripcionProyecto,
    c.nombre AS Cliente,
    e.nombre AS Empresa,
    s.descripcion AS Servicio,
    t.nombre AS Tecnologia,
    p.horasTotales AS HorasTotales
FROM proyecto p
JOIN servicio s ON p.servicio = s.idServicio
JOIN cliente c ON s.cliente = c.idCliente
JOIN empresa e ON c.empresa = e.idEmpresa
JOIN tecnologia t ON s.tecnologia = t.idTecnologia
WHERE p.horasTotales > 0;

-- Vista "Facturaciones de clientes"
CREATE VIEW facturacion_cliente AS
SELECT 
    c.nombre AS Cliente,
    e.nombre AS Empresa,
    SUM(f.monto) AS FacturacionTotal
FROM facturacion f
JOIN proyecto p ON f.id = p.horasTotales
JOIN servicio s ON p.servicio = s.idServicio
JOIN cliente c ON s.cliente = c.idCliente
JOIN empresa e ON c.empresa = e.idEmpresa
GROUP BY c.nombre, e.nombre;

-- Vista "Empleados por rol y proyecto"
CREATE VIEW empleados_por_rol_proyecto AS
SELECT 
    p.nombre AS Proyecto,
    e.nombre AS Empleado,
    r.nombre AS Rol
FROM proyecto p
JOIN empleado e ON p.empleado = e.idEmpleado
JOIN roles r ON e.rol = r.idRol;

-- Vista "Tareas x empleado"
CREATE VIEW tareas_empleado AS
SELECT 
    emp.nombre AS Empleado,
    t.descripcion AS Tarea,
    t.fecha AS FechaTarea,
    r.nombre AS Rol
FROM tarea t
JOIN empleado emp ON t.empleado = emp.idEmpleado
JOIN roles r ON t.rol = r.idRol
ORDER BY emp.nombre, t.fecha;

-- Vista "Servicios y Tecnologias x Cliente"
CREATE VIEW servicios_tecnologias_cliente AS
SELECT 
    c.nombre AS Cliente,
    e.nombre AS Empresa,
    s.descripcion AS Servicio,
    t.nombre AS Tecnologia
FROM cliente c
JOIN empresa e ON c.empresa = e.idEmpresa
JOIN servicio s ON c.idCliente = s.cliente
JOIN tecnologia t ON s.tecnologia = t.idTecnologia;


/*=========================================================
=                     STORED PROCEDURES                   =
=========================================================== */

-- Actualizacion de Facturaciones de Proyectos
CREATE PROCEDURE sp_ActualizarFacturacionProyecto(
    IN p_idProyecto INT,
    IN p_montoAdicional DECIMAL(10,2)
)
BEGIN
    DECLARE v_idFacturacion INT;
    
    -- Obtener el ID de facturación asociado al proyecto
    SELECT horasTotales INTO v_idFacturacion
    FROM proyecto
    WHERE idProyecto = p_idProyecto;

    -- Actualizar la facturación sumando el monto adicional
    UPDATE facturacion
    SET monto = monto + p_montoAdicional
    WHERE id = v_idFacturacion;
END;

-- Creacion de tareas para empleados
CREATE PROCEDURE sp_InsertarTareaEmpleado(
    IN p_descripcion VARCHAR(100),
    IN p_fecha DATE,
    IN p_rol INT,
    IN p_empleado INT
)
BEGIN
    INSERT INTO tarea (descripcion, fecha, rol, empleado)
    VALUES (p_descripcion, p_fecha, p_rol, p_empleado);
END;


/*=========================================================
=                        TRIGGERS                         =
=========================================================== */

-- Actualizacion de Monto: Facturacion
CREATE TRIGGER trg_ActualizarMontoFacturacion
AFTER INSERT ON facturacion
FOR EACH ROW
BEGIN
    UPDATE proyecto
    SET horasTotales = horasTotales + NEW.monto
    WHERE horasTotales = NEW.id;
END;

-- Actualizar datos de Empleados
CREATE TRIGGER trg_ActualizarEdadEmpleado
BEFORE UPDATE ON empleado
FOR EACH ROW
BEGIN
    SET NEW.edad = TIMESTAMPDIFF(YEAR, NEW.fechaNacimiento, CURDATE());
END;


/*=========================================================
=                        FUNCIONES                        =
=========================================================== */

-- Obtener montos facturados
CREATE FUNCTION obtener_montoTotal_facturado(p_idCliente INT)
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE v_montoTotal DECIMAL(10,2);
    
    SELECT SUM(f.monto)
    INTO v_montoTotal
    FROM facturacion f
    JOIN proyecto p ON f.id = p.horasTotales
    JOIN servicio s ON p.servicio = s.idServicio
    WHERE s.cliente = p_idCliente;

    RETURN v_montoTotal;
END;

-- Contar proyectos x empleado
CREATE FUNCTION contar_ProyectosPorEmpleado(p_idEmpleado INT)
RETURNS INT
BEGIN
    DECLARE v_totalProyectos INT;
    
    SELECT COUNT(*)
    INTO v_totalProyectos
    FROM proyecto
    WHERE empleado = p_idEmpleado;

    RETURN v_totalProyectos;
END;