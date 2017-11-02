server<-shinyServer(function(input, output) {
  
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
  
  #Información del INE
  datos<-espanya@data
  datos$CP<-as.numeric(datos$CODIGO)
  
  EV<-PCAXIS$DATA$value
  EV2<-EV
  EV2$SEX<-ifelse(EV2$Sexo=="Hombres","V",
                  ifelse(EV2$Sexo=="Mujeres","M","X"))
  EV2<-EV2[,-4]
  names(EV2)[2]<-"Periodo"
  EV3<-sqldf("select A.*,B.CP
             from EV2 as A
             left join provincias as B
             on A.Provincia=B.Provincias2")
  EV4<-dcast(EV3,Periodo + Edad + Provincia + SEX + CP ~ Funciones, value.var = "value")              
  
  #Tasa de mortalidad
  names(EV4)[6]<-"T_mort"
  #Promedio de años vividos el último año de vida
  names(EV4)[7]<-"Prom_anyos"
  #Riesgo de muerte
  names(EV4)[8]<-"Riesgo_muerte"
  #Supervivientes
  names(EV4)[9]<-"Supervivientes"
  #Defunciones teóricas
  names(EV4)[10]<-"Def_Teo"
  #Población estacionaria
  names(EV4)[11]<-"Pob_est"
  #Tiempo por vivir
  names(EV4)[12]<-"Tiempo_vivir"
  #Esperanza de vida
  names(EV4)[13]<-"Esp_vida"
  
  output$grafico_ine <- renderPlot({
    info_ine<-EV4;
    info_ine$X<-eval(parse(text=paste0("info_ine$",input$variable)));
    ine_info<-info_ine[info_ine$SEX==input$sexo2 & info_ine$Periodo==input$n2,];
    tabla<-aggregate(X ~ CP,ine_info,FUN=mean);
    tabla2<-sqldf("
                  select distinct
                  A.*, B.X
                  from datos as A
                  left join tabla as B
                  on A.CP = B.CP
                  ")
    espanya@data<-tabla2
    
    plotvar <- espanya@data$X
    nclr<-8
    #Blues BuGn BuPu GnBu Greens Greys Oranges OrRd PuBu PuBuGn PuRd Purples RdPu Reds
    #YlGn YlGnBu YlOrBr YlOrRd
    plotclr<-brewer.pal(nclr, "Blues")
    class<-classIntervals(plotvar,nclr,n=10,style="quantile")
    colcode<-findColours(class,plotclr)
    
    if(input$variable=="Prom_anyos") titulo<-"Promedio de años vividos el último año de vida"
    else if(input$variable=="Riesgo_muerte") titulo<-"Riesgo de muerte"
    else if(input$variable=="Supervivientes") titulo<-"Supervivientes"
    else if(input$variable=="Def_Teo") titulo<-"Defunciones teóricas"
    else if(input$variable=="Tiempo_vivir") titulo<-"Población estacionaria"
    else if(input$variable=="Esp_vida") titulo<-"Tiempo por vivir"
    else if(input$variable=="") titulo<-"Esperanza de vida"
    else titulo<-"Tasa de mortalidad"
    
    plot(espanya,col=colcode)
    #legend(-2000000,4900000,title="Promedio de años vividos el último año de vida", legend = names(attr(colcode, "table")), fill = attr(colcode,"palette"), cex = 0.6, bty = "n")
    legend(-1200000,4900000, title=titulo, legend = names(attr(colcode, "table")), fill = attr(colcode,"palette"), cex = 1, bty = "n")
    
  },width=800,height=600)
})