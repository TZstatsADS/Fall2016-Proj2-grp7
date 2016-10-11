library(leaflet)
library(shiny)
library(RColorBrewer)
library(dplyr)
library(ggplot2)
library(maps)
library(mapdata)


run <- read.csv("test.csv")


shinyServer(function(input,output,session){
  
  
  
  #output$map <- renderLeaflet({
  
  #Create icon for running spots 
  
  
  parkIcon <-
    makeIcon(
      iconUrl = "park icon.png",
      iconWidth = 40, iconHeight = 40
    )
  riverIcon <-
    makeIcon(
      iconUrl = "river icon.png",
      iconWidth = 40, iconHeight = 40
    ) 
  waterIcon <-
    makeIcon(
      iconUrl = "water icon.png",
      iconWidth = 40, iconHeight = 40
    )
  
  dogIcon <-
    makeIcon(
      iconUrl = "dog icon.png",
      iconWidth = 30, iconHeight = 30
    )
  
  
  #set preference for runing environment
  #run = read.csv("test.csv")
  preference <-  reactive({
    rrr <- run
    if(input$park == TRUE){
      rrr = filter(rrr, Park == 1)
    }
    else if (input$park ==FALSE){
      rrr = filter(rrr,Park == 3)
    }
      
    # if(input$safety == "Very Important to me!"){
    #   rrr = filter(rrr, Safety == "5")
    # }
    # if(input$safety == "Let it be okay"){
    #   rrr = filter(rrr, Safety >= 3) 
    # }
    # if(input$safety == "Not Care at all"){
    #   rrr = rrr
    # }
    # if(input$airquality == "Very Important to me!"){
    #   rrr = filter(rrr, Airquality == "5")
    # }
    # if(input$airquality == "Let it be okay"){
    #   rrr = filter(rrr, Airquality >= 3)
    # }
    # if(input$airquality == "Not Care at all"){
    #   rrr = rrr
    # }
    
    return(rrr)
    
  })
  
  # preference4 <-  reactive({
  #   rrr <- run
  #   if(input$park == FALSE){
  #     rrr = filter(rrr, Park == 1)
  #   }
  #   else if (input$park ==TRUE){
  #     rrr = filter(rrr,Park == 3)
  #     return(rrr)
  #   }
  #   })
  
  preference1 <- reactive({
    rrr <- run
    if(input$riverside == TRUE){
      rrr = filter(rrr, Riverside == "1")
    }
    else rrr = filter(rrr, Riverside == "3")
    return(rrr)
  })
  
  
  preference2 <- reactive({
    rrr <- run
    if(input$dog == TRUE){
      rrr = filter(rrr, Dog == "1")
    }
    else rrr = filter(rrr, Dog == "3")
    return(rrr)
  })
  
  preference3 <- reactive({
    rrr <- run
    if(input$drinkingfountain ==TRUE){
      rrr = filter(rrr, DrinkingFountain == "1")
    }
    else rrr = filter(rrr, DrinkingFountain == "3")
    return(rrr)
  })   

  
  
  
  
  
  
  
  
  
  
  #add markers for running spots
  
  output$map <- renderLeaflet({
    leaflet()%>% 
      # addTiles(urlTemplate = "https://api.mapbox.com/styles/v1/jackiecao/ciu0jcgy800ah2ipgpsw5usmi/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiamFja2llY2FvIiwiYSI6ImNpdTBqYXhmcjAxZ24ycGp3ZWZ1bTJoZ3QifQ.VytIrn5ZxVjtZjM15JPA9Q",
      #          attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      # )%>%
      addProviderTiles("Stamen.Watercolor") %>% 
      setView(lng = -73.97, lat = 40.75, zoom = 13)  
    
  })
  
  # observe({
  #   proxy =
  #     leafletProxy("map",session)
  #   if(!is.null(preference)){
  #   proxy %>%
  #     
  #     addMarkers( data = preference(),
  #       ~long, ~lat, icon = parkIcon
  #       ,popup = paste("*Address:",preference()$address,"<br>", layerId = "www")
  #     )
  #   }
  #   if(is.null(preference)){proxy %>%
  #     addMarkers( data = preference(),
  #                 ~long, ~lat, icon = parkIcon
  #                 ,popup = paste("*Address:",preference()$address,"<br>", layerId = "www")
  #     ) %>%
  #     removerMarkerCluster(layerId = "www")
  #   }
  # })
  
  observe({
    proxy =
      leafletProxy("map")
    proxy %>%
      addMarkers( data = preference(),
        ~long, ~lat, icon = parkIcon
        ,popup = paste("*Address:",preference()$address,"<br>", group = "parkers")
      )
  })
 
  observeEvent(input$park, {
    proxy <- leafletProxy("map")
    if (input$park ==TRUE) proxy %>% showGroup("parkers")
    else proxy %>% hideGroup("parkers")
  })
  
  observe({
    proxy=
      leafletProxy("map",data = preference1())
    proxy %>% 
      # clearMarkers() %>%
      addMarkers(#data = preference1(), 
        ~long, ~lat, icon = riverIcon
        ,popup = paste("*Address:",preference1()$address,"<br>")
      )
  })
  
  observe({
    proxy=
      leafletProxy("map",data = preference2())
    proxy %>%
      addMarkers(#data = preference2(),
        ~long, ~lat,icon = dogIcon
        ,popup = paste("*Address:",preference2()$address,"<br>")
      )
    
  })
  
  
  observe({
    proxy =
      leafletProxy("map",data = preference3()) 
    proxy %>% 
      # clearMarkers() %>%
      addMarkers(#data = preference2(),
        ~long, ~lat, icon = waterIcon
        ,popup = paste("*Address:",preference3()$address,"<br>", layerId = "w")
      )
    
  })
  
  
  
})




