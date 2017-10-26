server<-shinyServer(function(input, output) {
  
  #Lectura de la tabla de entrada
  TABLA_ENTRADA<-read.table("K:/Clientes/Proyectos/Zurich/2017/2. Tablas de Mortalidad/3.Work/8. Investigación/Shiny/JMG/TABLA_PREPARADA.txt"
                            ,header=TRUE
                            ,dec=","
                            ,sep=";")
  
  #Se define la cabecera de la tabla con condicionales
  output$cabecera <- renderText(paste("Análisis para",
                                      eval(
                                        if(input$desglose_anyos == FALSE){
                                          if(input$sexo != "X"){
                                            if(input$sexo == "V") "hombres"
                                            else "mujeres"
                                          }else "ambos sexos"
                                        }
                                        else{paste(
                                          if(input$sexo != "X"){
                                            if(input$sexo == "V") "hombres"
                                            else "mujeres"
                                          }else "ambos sexos"
                                          ,paste("en el año",input$n)
                                        )}
                                      )
  ))
  
  #Se define la cabecera del gráfico
  output$cabecera2 <- renderText(paste("Gráfico mortalidad por producto (",
                                       eval(
                                         if(input$desglose_anyos == FALSE){
                                           if(input$sexo != "X"){
                                             if(input$sexo == "V") "Sexo: Hombre, Año: 2008-2016)"
                                             else "Sexo: Mujer, Año: 2008-2016)"
                                           }else "Sexo: Ambos sexos, Año: 2008-2016)"
                                         }
                                         else{paste(
                                           if(input$sexo != "X"){
                                             if(input$sexo == "V") "Sexo: Hombre, "
                                             else "Sexo: Mujer, "
                                           }else "Sexo: Ambos sexos, "
                                           ,paste(paste("Año:",input$n),")")
                                         )}
                                       )
  ))
  
  # Construcción de la tabla resumen
  output$tabla <- renderTable({
    eval( #Es necesario definir una expresión que luego es evaluada
      if(input$desglose_anyos == FALSE){
        if(input$sexo != "X"){
          #Cálculo de la información resumida
          tabla<-aggregate(cbind(POLIZAS,EXPOSICION,SINIESTROS) ~ BBDD,TABLA_ENTRADA[TABLA_ENTRADA$SEX==input$sexo,],FUN=sum)
          tabla$POLIZAS<-format(tabla$POLIZAS,digits=0,scientific=999); #Se quitan decimales
          tabla$SINIESTROS<-format(tabla$SINIESTROS,digits=0,scientific=999); #Se quitan decimales
          tabla
        }
        else{
          tabla<-aggregate(cbind(POLIZAS,EXPOSICION,SINIESTROS) ~ BBDD,TABLA_ENTRADA,FUN=sum)
          tabla$POLIZAS<-format(tabla$POLIZAS,digits=0,scientific=999);
          tabla$SINIESTROS<-format(tabla$SINIESTROS,digits=0,scientific=999);
          tabla
        }
      }
      else{
        if(input$sexo != "X"){
          tabla<-aggregate(cbind(POLIZAS,EXPOSICION,SINIESTROS) ~ BBDD,TABLA_ENTRADA[TABLA_ENTRADA$SEX==input$sexo & TABLA_ENTRADA$ID_ANYO==input$n,],FUN=sum)
          tabla$POLIZAS<-format(tabla$POLIZAS,digits=0,scientific=999);
          tabla$SINIESTROS<-format(tabla$SINIESTROS,digits=0,scientific=999);
          tabla
        }
        else{
          tabla<-aggregate(cbind(POLIZAS,EXPOSICION,SINIESTROS) ~ BBDD,TABLA_ENTRADA[TABLA_ENTRADA$ID_ANYO==input$n,],FUN=sum);
          tabla$POLIZAS<-format(tabla$POLIZAS,digits=0,scientific=999);
          tabla$SINIESTROS<-format(tabla$SINIESTROS,digits=0,scientific=999);
          tabla
        }
      }
    )
  })
  
  output$grafico_qx <- renderPlot({
    eval( #Es necesario definir una expresión que luego es evaluada para construir la tabla de trabajo
      if(input$desglose_anyos == FALSE){
        if(input$sexo != "X"){
          tabla<-aggregate(cbind(EXPOSICION,SINIESTROS) ~ BBDD + EDAD,TABLA_ENTRADA[TABLA_ENTRADA$SEX==input$sexo,],FUN=sum)
        }
        else{
          tabla<-aggregate(cbind(EXPOSICION,SINIESTROS) ~ BBDD + EDAD,TABLA_ENTRADA,FUN=sum)
          
        }
      }
      else{
        if(input$sexo != "X"){
          tabla<-aggregate(cbind(EXPOSICION,SINIESTROS) ~ BBDD + EDAD,TABLA_ENTRADA[TABLA_ENTRADA$SEX==input$sexo & TABLA_ENTRADA$ID_ANYO==input$n,],FUN=sum)
          
        }
        else{
          tabla<-aggregate(cbind(EXPOSICION,SINIESTROS) ~ BBDD + EDAD,TABLA_ENTRADA[TABLA_ENTRADA$ID_ANYO==input$n,],FUN=sum);
          
        }
      }
    )
    # Una vez se han aplicado los filtros necesarios se calcula Qx y su logaritmo
    tabla$QX<-tabla$SINIESTROS/tabla$EXPOSICION
    tabla$LQX<-log(tabla$QX)
    tabla<-tabla[tabla$LQX != -Inf,]
    
    #Gráfico de las tasas de mortalidad
    plot(tabla$EDAD,tabla$LQX,col=tabla$BBDD, pch=16, xlab="Edad", ylab="Logaritmo(qx)")
    legend('bottomright', legend = levels(tabla$BBDD), col = 1:length(levels(tabla$BBDD)), cex = 0.8, pch = 16)
  })
})