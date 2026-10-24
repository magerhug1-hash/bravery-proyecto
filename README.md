# Bravery — cine para comprender, dialogar y actuar

Bravery es una propuesta de plataforma educativa para instituciones escolares. Organiza películas con temáticas sociales por etapa escolar y tema, para apoyar conversaciones guiadas, cuidadosas y adecuadas a la edad. No diagnostica estudiantes ni comunidades y no sustituye el acompañamiento educativo o profesional.

## Objetivo
Facilitar a escuelas una selección de películas y recursos de diálogo sobre temas como acceso a la educación, pobreza, migración, desigualdad, inclusión, bullying, violencia e igualdad de género.

## Contexto local
El proyecto toma como referencia el Diagnóstico del municipio de Aguascalientes (SEPLADE/SEIEG, 2024), que identifica necesidades de salud, educación y protección para la población infantil y destaca la relevancia de la población joven.

Fuente: [Diagnóstico del municipio de Aguascalientes (PDF)](https://egobierno2.aguascalientes.gob.mx/seplade/seieg/archivosVarios/Diagnosticos/001.%20Diagn%C3%B3stico%20municipio%20Aguascalientes.pdf).

## Archivos
- `bravery.sql`: crea las tablas relacionales, índices, etapas y temas iniciales; carga 15 películas y sus relaciones con etapas/temas.
- `bravery.R`: conecta una base SQLite a RStudio, ejecuta consultas INNER JOIN/GROUP BY, muestra una vista previa y genera un gráfico.
- `README.md`: propósito, instalación, instrucciones y criterios éticos.

## Modelo de datos
- `pelicula`: catálogo de títulos y advertencias de contenido.
- `etapa_educativa`: niveles y rangos de edad orientativos.
- `pelicula_etapa`: tabla puente con edad sugerida y nota educativa.
- `tema_social`: catálogo de temas.
- `pelicula_tema`: tabla puente película-tema.
- `institucion`: escuelas u otras instituciones.
- `proyeccion`: programación de películas por institución.

Las claves primarias (PK) identifican cada registro y las claves foráneas (FK) conectan las tablas. Las tablas puente implementan relaciones muchos-a-muchos.

## Cómo crear la base de datos
1. Abre DB Browser for SQLite y crea una base nueva, por ejemplo `bravery.sqlite`.
2. Ve a **Execute SQL**, abre `bravery.sql` y ejecuta todo el script.
3. Pulsa **Write Changes** para guardar.

## Cómo ejecutar la demo de R
1. Abre `bravery.R` en RStudio.
2. Si hace falta, instala los paquetes `DBI`, `RSQLite` y `ggplot2`.
3. Ejecuta el script y selecciona el archivo SQLite cuando aparezca el selector.

## Uso responsable y límites
- Las edades son recomendaciones editoriales, no clasificaciones oficiales; verifica la clasificación local antes de exhibir cada título.
- Incluye advertencias de contenido y acompañamiento docente para temas sensibles.
- No recolectes datos personales o sensibles del alumnado para recomendar películas.
- Diversifica voces, países y experiencias; evita asociar una colonia o grupo con un único problema.
- El recuento de películas por tema o etapa describe el catálogo curado, no la prevalencia de una problemática social.

## Licencias y derechos
Este repositorio contiene scripts y metadatos descriptivos. No incluye copias de películas ni concede derechos de exhibición; cada institución debe verificar licencias y permisos correspondientes.

## Estado del proyecto
Prototipo académico/educativo. Las recomendaciones de edad y notas requieren revisión por personal docente y consulta de clasificaciones oficiales.
