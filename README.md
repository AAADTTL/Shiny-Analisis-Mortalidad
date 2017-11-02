# Shiny-Analisis-Mortalidad
Análisis de las tasas de mortalidad y pólizas por producto

El programa principal es "Programa Principal.R". Es necesario tener instalado R para poder ejecutarlo.

El progama ui.R contiene la interfacce de la app.

El progama server.R contiene la programación necesaria para el correcto funcionamiento de la app.

Datos.zip contiene el "workspace" de R denominado Datos.RData el cual almacena la información externa necesaria:
  * Código CCAA y provincias.csv: contiene información del código de provincia para poder incluir datos.
  * EV.px: información de mortalidad del INE.
  * TABLA_INFORMACION: información de compañía.
  * Provincias_ETRS89_30N.shp: Provincias_ETRS89_30N.shp es "shapefile" que contiene la información de provincias para poder graficar el mapa de españa con esta desagregación.
