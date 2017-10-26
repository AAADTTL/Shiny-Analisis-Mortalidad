library(shiny)

ui<-shinyUI(fluidPage(
  
  # Título de la aplicación
  headerPanel("Análisis Mortalidad"),
  
  # Deslizador con el año
  sidebarPanel(sliderInput("n", "Año:", min = 2008, max = 2016, value = 2016, step=1)),
  
  #Marcador si se desglosa o no por años
  checkboxInput("desglose_anyos", label = "Desglose por años", value = FALSE),
  
  
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
)
)