# Bravery — consulta del catálogo SQLite en RStudio
# Si hace falta, instala una sola vez: install.packages(c("DBI", "RSQLite", "ggplot2"))

library(DBI)
library(RSQLite)
library(ggplot2)

# Elige el archivo .sqlite o .db creado al ejecutar bravery.sql en DB Browser.
db_path <- file.choose()
con <- dbConnect(SQLite(), db_path)

# Consulta compleja: cruza películas, etapas y temas sociales.
consulta_temas <- paste(
  "SELECT e.nombre AS etapa, t.nombre AS tema_social,",
  "COUNT(DISTINCT p.pelicula_id) AS total_peliculas",
  "FROM pelicula AS p",
  "INNER JOIN pelicula_etapa AS pe ON pe.pelicula_id = p.pelicula_id",
  "INNER JOIN etapa_educativa AS e ON e.etapa_id = pe.etapa_id",
  "INNER JOIN pelicula_tema AS pt ON pt.pelicula_id = p.pelicula_id",
  "INNER JOIN tema_social AS t ON t.tema_id = pt.tema_id",
  "GROUP BY e.etapa_id, e.nombre, t.tema_id, t.nombre",
  "ORDER BY e.edad_min, t.nombre;",
  sep = " ")
resultado_temas <- dbGetQuery(con, consulta_temas)
print(head(resultado_temas, 10))

# Resumen por etapa para generar una gráfica sencilla.
consulta_etapas <- paste(
  "SELECT e.nombre AS etapa, COUNT(DISTINCT p.pelicula_id) AS total_peliculas",
  "FROM pelicula AS p",
  "INNER JOIN pelicula_etapa AS pe ON pe.pelicula_id = p.pelicula_id",
  "INNER JOIN etapa_educativa AS e ON e.etapa_id = pe.etapa_id",
  "GROUP BY e.etapa_id, e.nombre",
  "ORDER BY e.edad_min;",
  sep = " ")
por_etapa <- dbGetQuery(con, consulta_etapas)
print(por_etapa)

# Vista rápida en RStudio.
ggplot(por_etapa, aes(x = factor(etapa, levels = etapa), y = total_peliculas, fill = etapa)) +
  geom_col(show.legend = FALSE, width = 0.62) +
  geom_text(aes(label = total_peliculas), vjust = -0.4, fontface = "bold") +
  scale_fill_manual(values = c("#D7A948", "#268C8F", "#7A58A5")) +
  labs(title = "Películas del catálogo por etapa", x = NULL,
       y = "Títulos en la muestra curada") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold", color = "#16324F"),
        panel.grid.minor = element_blank())

# El gráfico cuenta películas del catálogo; no mide incidencia de problemas sociales.
dbDisconnect(con)
