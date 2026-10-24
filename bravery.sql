-- BRAVERY: esquema relacional y carga del catálogo inicial
-- Ejecutar este archivo en una base SQLite vacía usando DB Browser for SQLite.
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS institucion (
    institucion_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    tipo TEXT,
    municipio TEXT
);

CREATE TABLE IF NOT EXISTS pelicula (
    pelicula_id INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo TEXT NOT NULL,
    anio INTEGER CHECK (anio IS NULL OR anio BETWEEN 1888 AND 2100),
    pais TEXT,
    sinopsis TEXT,
    advertencias_contenido TEXT
);

CREATE TABLE IF NOT EXISTS etapa_educativa (
    etapa_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL UNIQUE,
    edad_min INTEGER NOT NULL CHECK (edad_min >= 0),
    edad_max INTEGER CHECK (edad_max IS NULL OR edad_max >= edad_min)
);

CREATE TABLE IF NOT EXISTS tema_social (
    tema_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT
);

CREATE TABLE IF NOT EXISTS pelicula_etapa (
    pelicula_id INTEGER NOT NULL,
    etapa_id INTEGER NOT NULL,
    edad_orientativa INTEGER NOT NULL CHECK (edad_orientativa >= 0),
    nota_educativa TEXT,
    PRIMARY KEY (pelicula_id, etapa_id),
    FOREIGN KEY (pelicula_id) REFERENCES pelicula(pelicula_id) ON DELETE CASCADE,
    FOREIGN KEY (etapa_id) REFERENCES etapa_educativa(etapa_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS pelicula_tema (
    pelicula_id INTEGER NOT NULL,
    tema_id INTEGER NOT NULL,
    PRIMARY KEY (pelicula_id, tema_id),
    FOREIGN KEY (pelicula_id) REFERENCES pelicula(pelicula_id) ON DELETE CASCADE,
    FOREIGN KEY (tema_id) REFERENCES tema_social(tema_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS proyeccion (
    proyeccion_id INTEGER PRIMARY KEY AUTOINCREMENT,
    institucion_id INTEGER NOT NULL,
    pelicula_id INTEGER NOT NULL,
    fecha TEXT, -- formato AAAA-MM-DD
    grupo TEXT,
    notas TEXT,
    FOREIGN KEY (institucion_id) REFERENCES institucion(institucion_id) ON DELETE RESTRICT,
    FOREIGN KEY (pelicula_id) REFERENCES pelicula(pelicula_id) ON DELETE RESTRICT
);

INSERT OR IGNORE INTO etapa_educativa (nombre, edad_min, edad_max) VALUES
('Primaria', 6, 11), ('Secundaria', 12, 14), ('Preparatoria', 15, 18);

INSERT OR IGNORE INTO tema_social (nombre, descripcion) VALUES
('Acceso a la educación', 'Barreras para ingresar o continuar estudiando'),
('Pobreza', 'Falta de recursos y dificultades para cubrir necesidades básicas'),
('Migración', 'Desplazamiento y separación familiar'),
('Violencia', 'Violencia en la familia, comunidad o instituciones'),
('Desigualdad', 'Diferencias en oportunidades y condiciones de vida'),
('Inclusión', 'Respeto a las diferencias y participación'),
('Bullying', 'Acoso y violencia entre estudiantes'),
('Igualdad de género', 'Derechos y oportunidades sin discriminación de género'),
('Adicciones', 'Consumo problemático y sus efectos');

CREATE INDEX IF NOT EXISTS idx_pelicula_etapa_etapa ON pelicula_etapa(etapa_id);
CREATE INDEX IF NOT EXISTS idx_pelicula_tema_tema ON pelicula_tema(tema_id);
CREATE INDEX IF NOT EXISTS idx_proyeccion_institucion ON proyeccion(institucion_id);
CREATE INDEX IF NOT EXISTS idx_proyeccion_pelicula ON proyeccion(pelicula_id);

-- Carga inicial de 15 películas y sus relaciones:
-- BRAVERY: carga inicial de películas, etapas y temas sociales
-- Ejecuta este archivo después de crear las tablas del esquema.
-- Las edades son orientativas, no clasificaciones oficiales.
PRAGMA foreign_keys = ON;

-- Etapas escolares necesarias para vincular las películas.
INSERT OR IGNORE INTO etapa_educativa (nombre, edad_min, edad_max) VALUES
('Primaria', 6, 11),
('Secundaria', 12, 14),
('Preparatoria', 15, 18);

-- Temas adicionales que usa el catálogo. Si ya existen, no se duplican.
INSERT OR IGNORE INTO tema_social (nombre, descripcion) VALUES
('Seguridad alimentaria', 'Acceso suficiente y estable a los alimentos'),
('Dificultades de aprendizaje', 'Necesidades de aprendizaje y apoyos educativos'),
('Convivencia escolar', 'Relaciones, disciplina y bienestar dentro de la escuela'),
('Discriminación', 'Trato desigual por origen, clase, identidad u otras diferencias'),
('Identidad cultural', 'Pertenencia, cultura y expresión de las comunidades'),
('Desapariciones', 'Desaparición de personas y búsqueda de familiares'),
('Desplazamiento', 'Salida forzada del hogar por violencia u otras circunstancias'),
('Derechos de la niñez', 'Protección, bienestar y derechos de niñas, niños y adolescentes');

-- Películas. La condición NOT EXISTS permite ejecutar de nuevo sin duplicar títulos/años.
INSERT INTO pelicula (titulo, anio, pais, sinopsis, advertencias_contenido)
SELECT 'Binta y la gran idea', 2004, 'Senegal',
       'Cortometraje sobre educación, igualdad entre niñas y niños y estereotipos de género.',
       'Revisar el contexto cultural y acompañar con diálogo.'
WHERE NOT EXISTS (SELECT 1 FROM pelicula WHERE titulo='Binta y la gran idea' AND anio=2004);

INSERT INTO pelicula (titulo, anio, pais, sinopsis, advertencias_contenido)
SELECT 'Camino a la escuela', 2013, 'Francia',
       'Documental sobre niñas y niños que enfrentan dificultades para llegar a la escuela.',
       'Documental; contextualizar las distintas realidades mostradas.'
WHERE NOT EXISTS (SELECT 1 FROM pelicula WHERE titulo='Camino a la escuela' AND anio=2013);

INSERT INTO pelicula (titulo, anio, pais, sinopsis, advertencias_contenido)
SELECT 'El último vagón', 2023, 'México',
       'Una maestra y sus estudiantes en una escuela rural; aborda educación y barreras para continuar estudiando.',
       'Verificar clasificación local de la versión a exhibir.'
WHERE NOT EXISTS (SELECT 1 FROM pelicula WHERE titulo='El último vagón' AND anio=2023);

INSERT INTO pelicula (titulo, anio, pais, sinopsis, advertencias_contenido)
SELECT 'Extraordinario (Wonder)', 2017, 'Estados Unidos',
       'Un estudiante enfrenta el acoso escolar y busca ser aceptado; trata inclusión y empatía.',
       'Incluye situaciones de bullying.'
WHERE NOT EXISTS (SELECT 1 FROM pelicula WHERE titulo='Extraordinario (Wonder)' AND anio=2017);

INSERT INTO pelicula (titulo, anio, pais, sinopsis, advertencias_contenido)
SELECT 'El niño que domó el viento', 2019, 'Reino Unido / Malaui',
       'Un joven utiliza sus conocimientos para ayudar a su comunidad ante la pobreza y la escasez de alimentos.',
       'Incluye escenas de dificultad económica y escasez.'
WHERE NOT EXISTS (SELECT 1 FROM pelicula WHERE titulo='El niño que domó el viento' AND anio=2019);

INSERT INTO pelicula (titulo, anio, pais, sinopsis, advertencias_contenido)
SELECT 'La bicicleta verde', 2012, 'Arabia Saudita',
       'Una niña busca autonomía en un entorno con restricciones sociales y de género.',
       'Conversar sobre igualdad de género y diferencias culturales.'
WHERE NOT EXISTS (SELECT 1 FROM pelicula WHERE titulo='La bicicleta verde' AND anio=2012);

INSERT INTO pelicula (titulo, anio, pais, sinopsis, advertencias_contenido)
SELECT 'Radical', 2023, 'México',
       'Un docente busca despertar el interés por aprender en una escuela pública con recursos limitados.',
       'Temas de desigualdad y dificultades educativas.'
WHERE NOT EXISTS (SELECT 1 FROM pelicula WHERE titulo='Radical' AND anio=2023);

INSERT INTO pelicula (titulo, anio, pais, sinopsis, advertencias_contenido)
SELECT 'La misma luna', 2007, 'México / Estados Unidos',
       'Un niño y su madre viven separados por la migración y buscan reunirse.',
       'Incluye separación familiar y dificultades del proceso migratorio.'
WHERE NOT EXISTS (SELECT 1 FROM pelicula WHERE titulo='La misma luna' AND anio=2007);

INSERT INTO pelicula (titulo, anio, pais, sinopsis, advertencias_contenido)
SELECT 'Estrellas en la Tierra', 2007, 'India',
       'Un niño con dificultades de aprendizaje encuentra apoyo para aprender de una manera que se ajuste a sus necesidades.',
       'Incluye frustración escolar y dificultades de aprendizaje.'
WHERE NOT EXISTS (SELECT 1 FROM pelicula WHERE titulo='Estrellas en la Tierra' AND anio=2007);

INSERT INTO pelicula (titulo, anio, pais, sinopsis, advertencias_contenido)
SELECT 'Los coristas', 2004, 'Francia',
       'Un profesor transforma la convivencia de un grupo de estudiantes mediante la música y el acompañamiento.',
       'Incluye disciplina estricta y conflictos escolares.'
WHERE NOT EXISTS (SELECT 1 FROM pelicula WHERE titulo='Los coristas' AND anio=2004);

INSERT INTO pelicula (titulo, anio, pais, sinopsis, advertencias_contenido)
SELECT 'Escritores de la libertad', 2007, 'Estados Unidos',
       'Una docente trabaja con estudiantes que enfrentan discriminación, conflictos y desigualdad en su entorno escolar.',
       'Puede incluir lenguaje fuerte, discriminación y situaciones de violencia.'
WHERE NOT EXISTS (SELECT 1 FROM pelicula WHERE titulo='Escritores de la libertad' AND anio=2007);

INSERT INTO pelicula (titulo, anio, pais, sinopsis, advertencias_contenido)
SELECT 'Machuca', 2004, 'Chile',
       'La amistad entre dos estudiantes de distintos orígenes se desarrolla en un contexto de desigualdad y polarización política.',
       'Incluye conflicto político y escenas de violencia.'
WHERE NOT EXISTS (SELECT 1 FROM pelicula WHERE titulo='Machuca' AND anio=2004);

INSERT INTO pelicula (titulo, anio, pais, sinopsis, advertencias_contenido)
SELECT 'Ya no estoy aquí', 2019, 'México',
       'Un joven enfrenta el desplazamiento y la pérdida de su entorno cultural y comunitario.',
       'Incluye violencia y situaciones difíciles.'
WHERE NOT EXISTS (SELECT 1 FROM pelicula WHERE titulo='Ya no estoy aquí' AND anio=2019);

INSERT INTO pelicula (titulo, anio, pais, sinopsis, advertencias_contenido)
SELECT 'La jaula de oro', 2013, 'México',
       'Jóvenes migrantes atraviesan riesgos, explotación y violencia durante su viaje.',
       'Tema sensible; incluye violencia y riesgos durante la migración.'
WHERE NOT EXISTS (SELECT 1 FROM pelicula WHERE titulo='La jaula de oro' AND anio=2013);

INSERT INTO pelicula (titulo, anio, pais, sinopsis, advertencias_contenido)
SELECT 'Sin señas particulares', 2020, 'México',
       'Una madre busca a su hijo desaparecido durante su trayecto migratorio.',
       'Tema emocionalmente intenso; aborda desaparición y violencia.'
WHERE NOT EXISTS (SELECT 1 FROM pelicula WHERE titulo='Sin señas particulares' AND anio=2020);

-- Etapas recomendadas y edad orientativa por película.
WITH recomendaciones(titulo, etapa, edad, nota) AS (
    VALUES
    ('Binta y la gran idea','Primaria',8,'Cortometraje breve; conversar sobre igualdad y educación.'),
    ('Camino a la escuela','Primaria',9,'Dialogar sobre las barreras para acceder a la escuela.'),
    ('El último vagón','Primaria',10,'Conversar sobre educación rural y oportunidades.'),
    ('Extraordinario (Wonder)','Primaria',8,'Tratar el bullying, la empatía y la inclusión.'),
    ('El niño que domó el viento','Primaria',10,'Acompañar los temas de pobreza y escasez de alimentos.'),
    ('La bicicleta verde','Primaria',10,'Conversar sobre igualdad y autonomía.'),
    ('Radical','Secundaria',12,'Debatir sobre desigualdad educativa y enseñanza.'),
    ('La misma luna','Secundaria',12,'Conversar sobre migración y separación familiar.'),
    ('Estrellas en la Tierra','Secundaria',12,'Tratar inclusión y distintas formas de aprender.'),
    ('Los coristas','Secundaria',12,'Debatir sobre disciplina, apoyo y convivencia escolar.'),
    ('Escritores de la libertad','Secundaria',13,'Recomendada con guía docente por sus temas sensibles.'),
    ('Machuca','Preparatoria',14,'Acompañar con contexto histórico y diálogo.'),
    ('Ya no estoy aquí','Preparatoria',15,'Incluir advertencia y conversar sobre identidad y desplazamiento.'),
    ('La jaula de oro','Preparatoria',16,'Recomendada con acompañamiento por sus escenas y temas.'),
    ('Sin señas particulares','Preparatoria',16,'Recomendada con acompañamiento por su intensidad emocional.')
)
INSERT OR IGNORE INTO pelicula_etapa (pelicula_id, etapa_id, edad_orientativa, nota_educativa)
SELECT p.pelicula_id, e.etapa_id, r.edad, r.nota
FROM recomendaciones r
JOIN pelicula p ON p.titulo = r.titulo
JOIN etapa_educativa e ON e.nombre = r.etapa;

-- Temas sociales asociados a cada película.
WITH relaciones(titulo, tema) AS (
    VALUES
    ('Binta y la gran idea','Acceso a la educación'),
    ('Binta y la gran idea','Igualdad de género'),
    ('Camino a la escuela','Acceso a la educación'),
    ('Camino a la escuela','Pobreza'),
    ('Camino a la escuela','Desigualdad'),
    ('El último vagón','Acceso a la educación'),
    ('El último vagón','Desigualdad'),
    ('Extraordinario (Wonder)','Inclusión'),
    ('Extraordinario (Wonder)','Bullying'),
    ('El niño que domó el viento','Acceso a la educación'),
    ('El niño que domó el viento','Pobreza'),
    ('El niño que domó el viento','Seguridad alimentaria'),
    ('La bicicleta verde','Igualdad de género'),
    ('La bicicleta verde','Inclusión'),
    ('Radical','Acceso a la educación'),
    ('Radical','Desigualdad'),
    ('Radical','Inclusión'),
    ('La misma luna','Migración'),
    ('La misma luna','Pobreza'),
    ('La misma luna','Desigualdad'),
    ('Estrellas en la Tierra','Dificultades de aprendizaje'),
    ('Estrellas en la Tierra','Inclusión'),
    ('Estrellas en la Tierra','Acceso a la educación'),
    ('Los coristas','Acceso a la educación'),
    ('Los coristas','Convivencia escolar'),
    ('Los coristas','Derechos de la niñez'),
    ('Escritores de la libertad','Discriminación'),
    ('Escritores de la libertad','Violencia'),
    ('Escritores de la libertad','Acceso a la educación'),
    ('Machuca','Desigualdad'),
    ('Machuca','Discriminación'),
    ('Machuca','Violencia'),
    ('Ya no estoy aquí','Identidad cultural'),
    ('Ya no estoy aquí','Desplazamiento'),
    ('Ya no estoy aquí','Desigualdad'),
    ('Ya no estoy aquí','Violencia'),
    ('La jaula de oro','Migración'),
    ('La jaula de oro','Violencia'),
    ('La jaula de oro','Pobreza'),
    ('La jaula de oro','Desigualdad'),
    ('Sin señas particulares','Desapariciones'),
    ('Sin señas particulares','Migración'),
    ('Sin señas particulares','Violencia')
)
INSERT OR IGNORE INTO pelicula_tema (pelicula_id, tema_id)
SELECT p.pelicula_id, t.tema_id
FROM relaciones r
JOIN pelicula p ON p.titulo = r.titulo
JOIN tema_social t ON t.nombre = r.tema;

-- Verifica que se cargaron las películas y sus relaciones.
SELECT p.titulo, p.anio, e.nombre AS etapa, pe.edad_orientativa
FROM pelicula p
LEFT JOIN pelicula_etapa pe ON pe.pelicula_id = p.pelicula_id
LEFT JOIN etapa_educativa e ON e.etapa_id = pe.etapa_id
ORDER BY e.etapa_id, p.titulo;
