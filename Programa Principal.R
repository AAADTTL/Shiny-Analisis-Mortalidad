
# Carga de librarías
library(shiny)
library(shinythemes)

library(maptools)
library(RColorBrewer)
library(ggmap)
library(classInt)
library(rgeos)
library(sqldf)
library(pxR)
library(reshape2)

# Carga Datos
download.file("https://raw.githubusercontent.com/AAADTTL/Shiny-Analisis-Mortalidad/master/Datos.zip",
              "Datos.zip",method="auto")
load(unzip("Datos.zip"))

# Carga interface y programación de la aplicación
source("https://raw.githubusercontent.com/AAADTTL/Shiny-Analisis-Mortalidad/master/ui.R",encoding="UTF-8")
source("https://raw.githubusercontent.com/AAADTTL/Shiny-Analisis-Mortalidad/master/server.R",encoding="UTF-8")

#Ejecuta el programa
shinyApp(ui,server)

