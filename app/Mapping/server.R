library(leaflet)
library(shiny)
library(RColorBrewer)
library(dplyr)
library(ggplot2)
library(maps)
library(mapdata)

#read the data first, than comment on the code command
#run <- read.csv("map_point_withAddress_rescaleAQI.csv")


shinyServer(function(input,output){
  
  
  
  #output$map2 <- renderLeaflet({
  
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
  
  
  preference <-  reactive({
    rrr <- run
    if(input$park2 == TRUE){
      rrr = filter(rrr, Park == 1)
    }
    if(input$park2 == FALSE){
      rrr = filter(rrr,Park == 3)
    }
    if(input$safety2 == 5){
      rrr = filter(rrr, Safety == 5)
    }
    if(input$safety2 == 3){
      rrr = filter(rrr, Safety >= 3)
    }
    if(input$safety2 == 0){
      rrr = filter(rrr, Safety >0)
    }
    if(input$airquality2 == 5){
      rrr = filter(rrr, Airquality == 5)
    }
    if(input$airquality2 == 3){
      rrr = filter(rrr, Airquality >= 3)
    }
    if(input$airquality2 == 0){
      rrr = filter(rrr, Airquality >0)
    }
    return(rrr)
  })
  
  
  preference1 <- reactive({
    rrr <- run
    if(input$riverside == TRUE){
     rrr = filter(rrr, Riverside == 1)
    }
    if(input$riverside == FALSE){
      rrr = filter(rrr, Riverside == 3)
    }
    if(input$safety2 == 5){
      rrr = filter(rrr, Safety == 5)
    }
    if(input$safety2 == 3){
      rrr = filter(rrr, Safety >= 3)
    }
    if(input$safety2 == 0){
      rrr = filter(rrr, Safety >0)
    }
    if(input$airquality2 == 5){
      rrr = filter(rrr, Airquality == 5)
    }
    if(input$airquality2 == 3){
      rrr = filter(rrr, Airquality >= 3)
    }
    if(input$airquality2 == 0){
      rrr = filter(rrr, Airquality > 0)
    }
    return(rrr)
  })


  preference2 <- reactive({
    rrr <- run
    if(input$dog2 == TRUE){
      rrr = filter(rrr, Dog == 1)
    }
    if(input$dog2 == FALSE){
      rrr = filter(rrr, Dog == 3)
    }
    # if(input$safety2 == 5){
    #   rrr = filter(rrr, Safety == 5)
    # }
    # if(input$safety2 == 3){
    #   rrr = filter(rrr, Safety >= 3)
    # }
    # if(input$safety2 == 0){
    #   rrr = filter(rrr, Safety >0)
    # }
    # if(input$airquality2 == 5){
    #   rrr = filter(rrr, Airquality == 5)
    # }
    # if(input$airquality2 == 3){
    #   rrr = filter(rrr, Airquality >= 3)
    # }
    # if(input$airquality2 == 0){
    #   rrr = filter(rrr, Airquality > 0 )
    # }
    return(rrr)
  })

  preference3 <- reactive({
    rrr <- run
    if(input$drinkingfountain ==TRUE){
      rrr = filter(rrr, DrinkingFountains == 1)
    }
    if(input$drinkingfountain ==FALSE){
      rrr = filter(rrr, DrinkingFountains == 3)
    } 
    # if(input$safety2 == 5){
    #   rrr = filter(rrr, Safety == 5)
    # }
    # if(input$safety2 == 3){
    #   rrr = filter(rrr, Safety >= 3)
    # }
    # if(input$safety2 == 0){
    #   rrr = filter(rrr, Safety >0)
    # }
    # if(input$airquality2 == 5){
    #   rrr = filter(rrr, Airquality == 5)
    # }
    # if(input$airquality2 == 3){
    #   rrr = filter(rrr, Airquality >= 3)
    # }
    # if(input$airquality2 == 0){
    #   rrr = filter(rrr, Airquality > 0 )
    # }
    return(rrr)
  })

  
  #add markers for running spots
  
  output$map2 <- renderLeaflet({
    leaflet()%>% 
      # addTiles(urlTemplate = "https://api.mapbox.com/styles/v1/jackiecao/ciu0jcgy800ah2ipgpsw5usmi/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiamFja2llY2FvIiwiYSI6ImNpdTBqYXhmcjAxZ24ycGp3ZWZ1bTJoZ3QifQ.VytIrn5ZxVjtZjM15JPA9Q",
      #          attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      # )%>%
      addProviderTiles("Stamen.Watercolor") %>% 
      setView(lng = -73.97, lat = 40.75, zoom = 13)  
    
  })
  
  
  observe({
    proxy =
      leafletProxy("map2")
    proxy %>%
      addMarkers(data = preference(), 
        ~long, ~lat, icon = parkIcon
        ,popup = paste("*Address:",preference()$address,"<br>"), group = "Parks") %>%
          addMarkers(data = preference1(),
            ~long, ~lat, icon = riverIcon
            ,popup = paste("*Address:",preference1()$address,"<br>"), group = "Rivers & Pools"
          ) %>%
      addMarkers(data = preference2(),
        ~long, ~lat, icon = dogIcon
        ,popup = paste("*Address:",preference2()$address,"<br>"), group = "Dogs"
      ) %>%
      addMarkers(data = preference3(),
                 ~long, ~lat, icon = waterIcon
                 ,popup = paste("*Address:",preference3()$address,"<br>"), group = "Water Fountains"
      ) %>%
      addLayersControl(
        position = "topright",
        overlayGroups = c("Parks","Rivers & Pools","Dogs","Water Fountains"),
        options = layersControlOptions(collapsed = FALSE)
      ) 
  })

  # observe({
  #   proxy=
  #     leafletProxy("map2",data = preference1())
  #   proxy %>% 
  #     # clearMarkers() %>%
  #     addMarkers(#data = preference1(), 
  #       ~long, ~lat, icon = riverIcon
  #       ,popup = paste("*Address:",preference1()$address,"<br>"), group = "Rivers & Pools"
  #     ) %>% 
  #     addLayersControl(
  #      
  #       overlayGroups = c("Rivers & Pools"),
  #       options = layersControlOptions(collapsed = FALSE)
  #     )
  # })

  # observe({
  #   proxy=
  #     leafletProxy("map2",data = preference2())
  #   proxy %>%
  #     addMarkers(#data = preference2(),
  #       ~long, ~lat,icon = dogIcon
  #       ,popup = paste("*Address:",preference2()$address,"<br>")
  #     )
  #   
  # })
  
  
  # observe({
  #   proxy =
  #     leafletProxy("map2",data = preference3()) 
  #   proxy %>% 
  #     # clearMarkers() %>%
  #     addMarkers(#data = preference2(),
  #       ~long, ~lat, icon = waterIcon
  #       ,popup = paste("*Address:",preference3()$address,"<br>", layerId = "w")
  #     )
  #   
  # })
  
  
  
})




