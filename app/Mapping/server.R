library(leaflet)
library(shiny)
library(RColorBrewer)
library(dplyr)
library(ggplot2)
library(maps)
library(mapdata)



shinyServer(function(input,output,session){
  

     #output$map <- renderLeaflet({
  
        #Create icon for running spots 
       
        runIcon <-
        makeIcon(
        iconUrl = "runner icon.png",
        iconWidth = 25, iconHeight = 25,
        iconAnchorX = 13, iconAnchorY = 13
        )
#load the map
        # leaflet() %>% 
          # addTiles(urlTemplate = "https://api.mapbox.com/styles/v1/jackiecao/ciu0jcgy800ah2ipgpsw5usmi/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiamFja2llY2FvIiwiYSI6ImNpdTBqYXhmcjAxZ24ycGp3ZWZ1bTJoZ3QifQ.VytIrn5ZxVjtZjM15JPA9Q",
          #          attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
          # )%>%
            # addProviderTiles("CartoDB.Positron")%>%
            # setView(lng = -73.97, lat = 40.75, zoom = 13)  
            #addMarkers(data = run, icon = runIcon)


#set preference for runing environment
         run = read.csv("test.csv")

         preference <-  reactive({
                rrr <- run
                  if(input$park == TRUE){
                    rrr = filter(rrr, Park == 1)
                  }
                  if(input$riverside == TRUE){
                    rrr = filter(rrr, Riverside == 1)
                  }
                  if(input$dog == TRUE){
                    rrr = filter(rrr, Dog == "1")
                  }
                  if(input$drinkingfountain ==TRUE){
                    rrr = filter(rrr, DrinkingFountain == "1")
                  }
                  
                  if(input$safety == "Very Important to me!"){
                    filter(run, Safety == "5")
                  }
                  if(input$safety == "Let it be okay"){
                    filter(run, Safety == "3" | Safety == "4")
                  }
                  # if(input$safety == "Not Care at all"){
                  #   filter(run, Safety == "5")
                  # }
           return(rrr)

           })




 
 
#add markers for running spots
         output$map <- renderLeaflet({
           leaflet()%>% 
           # addTiles(urlTemplate = "https://api.mapbox.com/styles/v1/jackiecao/ciu0jcgy800ah2ipgpsw5usmi/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiamFja2llY2FvIiwiYSI6ImNpdTBqYXhmcjAxZ24ycGp3ZWZ1bTJoZ3QifQ.VytIrn5ZxVjtZjM15JPA9Q",
           #          attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
           # )%>%
           addProviderTiles("CartoDB.Positron")%>%
           #setView(lng = -73.97, lat = 40.75, zoom = 13) %>% 
           #addMarkers(data = run, ~long, ~lat,icon = runIcon)   
           addMarkers(data = preference(), ~long, ~lat, icon = runIcon
                      ,popup = paste("*Neighborhood:",preference()$Location, "<br>"))
         })
           
     
           #addMarkers(data = run, icon = runIcon)
             # observe({
             #          
             #          leafletProxy("output$map",data = preference()) %>%   
             #          clearMarkers() %>%
             #          addMarkers(data = preference(), lng = Long, lat = Lat, icon = runIcon
             #          ,popup = paste("*Neighborhood:",preference()$Location, "<br>")
             # 
             #   )
             #   })

     

})


   

