library(shiny)
library(dplyr)
library(readr)
library(ggplot2)
atletas <- read_csv("Juegos_Olimpicos.csv")
at1 <- atletas %>% filter(!is.na(Height) & !is.na(Weight))
shinyServer(function(input, output, session) {
    
    output$atletas <- DT::renderDataTable(
        atletas, extensions = 'Buttons', options = list(dom = 'Bfrtip', buttons = list('csv', 'excel'))
    )
    
    output$paises <- DT::renderDataTable({
        atletas %>% group_by(Team) %>% summarise(Gold = sum(Gold),
                                                 Silver = sum(Silver),
                                                 Bronze = sum(Bronze),
                                                 Total = Gold + Silver + Bronze,
                                                 .groups = 'drop') %>% 
            filter((Gold > input$gold[1] & Gold < input$gold[2]) &
                       (Silver > input$silver[1] & Silver < input$silver[2]) &
                       (Bronze > input$bronze[1] & Bronze < input$bronze[2]) &
                       (Total > input$total[1] & Total < input$total[2])) %>% arrange(-Gold)
        
        
        
    })
    
    output$Pedad <- renderPlot({
        edad <- at1 %>% filter((Year %in% input$year) & (Season %in% input$tipo)) %>% group_by(Sex, Age) %>% 
            summarise(Quantity = n(), .groups = 'drop') %>% filter(Age > input$edad[1] & Age < input$edad[2])
        ggplot(edad, aes(Age, Quantity, fill = Sex)) +
            geom_bar(stat = "identity", position = position_dodge()) + 
            labs(title = "Cantidad de atletas por edad")
        
    })
    output$Pestatura <- renderPlot({
        altura <- at1 %>% filter((Year %in% input$year) & (Season %in% input$tipo)) %>% group_by(Sex, Height) %>% 
            summarise(Quantity = n(), .groups = 'drop') %>% filter(Height > input$altura[1] & Height < input$altura[2])
        
        ggplot(altura, aes(Height, Quantity, fill = Sex)) +
            geom_bar(stat = "identity", position = position_dodge()) + 
            labs(title = "Cantidad de atletas por altura") 
    })
    output$Ppeso <- renderPlot({
        peso <- at1 %>% filter((Year %in% input$year) & (Season %in% input$tipo)) %>% group_by(Sex, Weight) %>% 
            summarise(Quantity = n(), .groups = 'drop') %>% filter(Weight > input$peso[1] & Weight < input$peso[2])
        
        ggplot(peso, aes(Weight, Quantity, fill = Sex)) +
            geom_bar(stat = "identity", position = position_dodge()) + 
            labs(title = "Cantidad de atletas por peso")
    })
    
    observe({
        query <- parseQueryString(session$clientData$url_search)
        separaciones <- query[["separaciones"]]
        bar_col <- query[["color"]]
        if(!is.null(separaciones)){
            updateSliderInput(session, "separaciones", value=as.numeric(separaciones))
        }
        if(!is.null(bar_col)){
            updateSelectInput(session, "colores", selected = bar_col)
        }
        
        
    })
    
    output$OlimpicHist <- renderPlot({
        
        separaciones <- seq(min(atletas$Age), max(atletas$Age), length.out = input$separaciones + 1)
        
        hist(atletas$Age, breaks = separaciones, col = input$colores, border = 'white')
    })
    
    observe({
        query <- parseQueryString(session$clientData$url_search)
        seps <- query[["seps"]]
        color_barras <- query[["color"]]
        variable <- query[["variable"]]
        if(!is.null(seps)){
            updateSliderInput(session, "seps", value=as.numeric(seps))
        }
        if(!is.null(color_barras)){
            updateSelectInput(session, "cambio_color", selected = color_barras)
        }
        if(!is.null(variable)){
            updateSelectInput(session, "variable", selected = variable)
        }
    })
    
    observe({
        
        seps<-input$seps
        color<-input$cambio_color
        variable <- input$variable
        
        if(session$clientData$url_port==''){
            u <- NULL
        } else {
            u <- paste0(":",
                        session$clientData$url_port)
        }
        
        marcador<-paste0("http://",
                         session$clientData$url_hostname,
                         u,
                         session$clientData$url_pathname,
                         "?","seps=",
                         seps,'&',
                         "color=",
                         color,"&",
                         "variable=",
                         variable)
        updateTextInput(session,"url",value = marcador)
        
    })
    
    output$OlimpicHist <- renderPlot({
        colu <- switch(input$variable,
                        Age = 4,
                        Height = 5,
                        Weight = 6)
        
        if(colu == 4){
            atletas_hist <- atletas$Age
            atletas_hist <- na.omit(atletas_hist)
            seps <- seq(min(atletas_hist), max(atletas_hist), length.out = input$seps)
            titu <- "Distribución de la Edad"
        }
        if(colu == 5){
            atletas_hist <- atletas$Height
            atletas_hist <- na.omit(atletas_hist)
            seps <- seq(min(atletas_hist), max(atletas_hist), length.out = input$seps)
            titu <- "Distribución de la Estatura"
        }
        if(colu == 6){
            atletas_hist <- atletas$Weight
            atletas_hist <- na.omit(atletas_hist)
            seps <- seq(min(atletas_hist), max(atletas_hist), length.out = input$seps)
            titu <- "Distribución del Peso"
        }
        
        hist(atletas_hist, breaks = seps, col = input$cambio_color, border = 'white', main = titu)
        
    })

})