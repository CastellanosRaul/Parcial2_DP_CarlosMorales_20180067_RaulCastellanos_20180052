library(shiny)
shinyUI(fluidPage(
    
    tabsetPanel(
        tabPanel("Descripcion",
                 h1("Parcial 1, Parte 2: Shiny App", align = "center"),
                 h1("Alumnos"),
                 h2("Carlos Morales 20180067"),
                 h2("Raul Castellanos 20180052"),
                 h2("Descripción"),
                 h4("En este parcial se aplicarán los conocimientos adquiridos sobre realizar Shiny Apps"),
                 h4("El app mostrará el análisis sobre los Juegos Olímpicos de invierno y verano
                    desde el año 1896 hasta el año 2016."),
                 h1("Datos generales de las pestañas disponibles"),
                 h3("Data Utilizada:"),
                 h4("Muestra la data que nosotros utilizamos y se podrá descargar en formato de Excel o CSV."),
                 h3("Histórico de países:"),
                 h4("Muestra el medallero histórico por país y permite filtrar por la cantidad de medallas de oro,"),
                 h4("plata, bronce o totales utilizando los sliders del panel lateral."),
                 h3("Datos_Atletas:"),
                 h4("Muestra la distribución de atletas según su peso, edad o estatura, aplicando distintos filtros:"),
                 h4("año de la olimpiada, temporada."),
                 h3("Parametros URL"),
                 h4("Para cambiar los filtros por medio de la URL, se deben seguir las siguientes instrucciones:"),
                 h4("Ejemplo: http://mishainyapp/?seps=5&color=red&variable=Age"),
                 h4("Separaciones (seps): seps = numero de separaciones deseado"), 
                 h4("Color del histograma (color_barras): color = gold, pink, red, lightblue"),
                 h4("variable a observar (variable): variable = Age, Height, Weight")
        ),
        
        tabPanel('Data Utilizada',
                 titlePanel("Atletas en los juegos olímpicos, entre los años 1896 y 2016"),
                 DT::dataTableOutput("atletas")
        ),
        
        # paises ------------------------------------------------------------------
        
        
        tabPanel('Historico de países',
                 sidebarLayout(
                     sidebarPanel(
                         sliderInput(
                             "gold","Gold",min = 0,max = 2500,value = c(0,2500),step = 50
                         ),
                         sliderInput(
                             "silver","Silver",min = 0,max = 1550,value = c(0,1550),step = 50
                         ),
                         sliderInput(
                             "bronze","Bronze",min = 0,max = 1250,value = c(0,1250),step = 50
                         ),
                         sliderInput(
                             "total","Total",min = 0,max = 5250,value = c(0,5250),step = 50
                         )
                     ),
                     mainPanel(
                         titlePanel("Medallas históricas por país"),
                         DT::dataTableOutput("paises"))
                 )
        ),
        
        # datos_atletas -----------------------------------------------------------
        
        tabPanel("Datos_Atletas",
                 sidebarLayout(
                     sidebarPanel(
                         sliderInput(
                             "edad","Rango Edad",min = 10,max = 74,value = c(0,74),step = 1
                         ),
                         sliderInput(
                             "altura","Rango Estatura",min = 125,max = 228,value = c(125,228),step = 1
                         ),
                         sliderInput(
                             "peso","Rango Peso",min = 24,max = 215,value = c(24,215),step = 1
                         ),
                         selectInput(
                             "year","Seleccione el año", choices = c("1896"=1896, "1900"=1900,"1904"=1904,"1906"=1906,"1908"=1908,
                                                                     "1912"=1912,"1920"=1920,"1924"=1924,"1928"=1928,"1932"=1932,
                                                                     "1936" = 1936, "1948" = 1948, "1952" = 1952, "1956" = 1956,
                                                                     "1960" = 1960, "1964" = 1964, "1968" = 1968, "1972" = 1972,
                                                                     "1976" = 1976, "1980" = 1980, "1984" = 1984, "1988" = 1988,
                                                                     "1992" = 1992, "1994" = 1992, "1996" = 1996, "1998" = 1998, 
                                                                     "2000" = 2000, "2002" = 2002, "2004" = 2004, "2006" = 2006,
                                                                     "2008"=2008,"2010"=2010,"2012"=2012,"2014"=2014,"2016"=2016),
                             multiple = TRUE, selected = c("2016","2014","2012","2010")
                         ),
                         selectInput(
                             "tipo","Seleccione tipo de olimpiada", choices = c("Summer"="Summer","Winter"="Winter"),multiple = TRUE,selected = c("Summer","Winter")
                         )
                     ),
                     mainPanel(
                         tabsetPanel(tabPanel(
                             "Distribucion por edad", plotOutput("Pedad")
                         ),
                         tabPanel(
                             "Distribucion por estatura", plotOutput("Pestatura")
                         ),
                         tabPanel(
                             "Distribucion por peso", plotOutput("Ppeso")
                         )
                         )
                     )
                 )
        ),
        # URL Parameter -----------------------------------------------------------
        tabPanel("Parametros URL",
                 sidebarLayout(
                     sidebarPanel(
                         sliderInput("seps",
                                     "Numero de separaciones:",
                                     min = 1,
                                     max = 100,
                                     value = 10),
                         selectInput("cambio_color",
                                     "Escoge el color:",
                                     choices = c('gold','pink','red','lightblue'),
                                     selected = 'darkgray'),
                         textInput("url","Parametro del_ RL: ",value = ""),
                         radioButtons("variable",label = "Selecciona una columna",
                                      choices = c("Age"= "Age", "Height"= "Height", "Weight"= "Weight"), selected = "Age")
                     ),
                     
                     # Show a plot of the generated distribution
                     mainPanel(
                         plotOutput("OlimpicHist")
                     )
                 )
        )
    )
))
