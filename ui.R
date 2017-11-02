
ui<-shinyUI(navbarPage(
  theme = shinytheme("cerulean"),
  
  title = "Estudio Mortalidad",
  
  tabPanel(readLines(textConnection("Análisis Cía.",encoding="UTF-8"),encoding="UTF-8"),
           
           # Título de la aplicación
           #headerPanel("Análisis Mortalidad"),
           
           # Deslizador con el año
           sidebarPanel(sliderInput("n", readLines(textConnection("Año:",encoding="UTF-8"),encoding="UTF-8"), min = 2008, max = 2016, value = 2016, step=1)),
           
           #Marcador si se desglosa o no por años
           checkboxInput("desglose_anyos", label = readLines(textConnection("Desglose por años",encoding="UTF-8"),encoding="UTF-8"), value = FALSE),
           
           
           #Filtro por Sexo
           radioButtons("sexo",label = "Filtrar por sexo del asegurado",choices = list("Ambos sexos" = "X", "Hombres" = "V", "Mujeres" = "M"),selected = "X"),
           
           
           # Muestra los resultados
           mainPanel(
             
             #Tabla resumen con cabecera
             h3(textOutput(outputId="cabecera")),
             tableOutput("tabla"),
             
             #Gráfico resumen con cabecera
             h3(textOutput(outputId="cabecera2")),
             plotOutput("grafico_qx")
             
           )
  ),
  
  tabPanel("Información INE",
           
           #sidebarPanel(
           #Desplegable
           selectInput(
             "variable",
             "Selecciona variable de estudio:",
             choices = c(
               "Tasa de mortalidad" = "T_mort",
               "Promedio de años vividos el último año de vida" = "Prom_anyos",
               "Riesgo de muerte" = "Riesgo_muerte",
               "Supervivientes" = "Supervivientes",
               "Defunciones teóricas" = "Def_Teo",
               "Población estacionaria" = "Pob_est",
               "Tiempo por vivir" = "Tiempo_vivir",
               "Esperanza de vida" = "Esp_vida"
             ),
             selected = "Tasa de mortalidad"
             
           ),
           
           # Deslizador con el año
           sidebarPanel(sliderInput("n2", readLines(textConnection("Año:",encoding="UTF-8"),encoding="UTF-8"), min = 1991, max = 2015, value = 2015, step=1)),
           
           #Filtro por Sexo
           radioButtons("sexo2",label = "Sexo:",choices = list("Ambos sexos" = "X", "Hombres" = "V", "Mujeres" = "M"),selected = "X"),
           #,width=12),  
           
           mainPanel(
             plotOutput("grafico_ine"),
             width = "200%", height = "400px"
           ) 
           
  )
)
)

