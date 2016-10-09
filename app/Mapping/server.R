library(leaflet)
library(shiny)
library(RColorBrewer)
library(dplyr)
library(ggplot2)
library(maps)
library(mapdata)


shinyServer(function(input,output){ 

     output$map <- renderLeaflet({
  
#load the ma3
        leaflet() %>% 
          #addTiles(urlTemplate = "https://api.mapbox.com/styles/v1/jackiecao/ciu0jcgy800ah2ipgpsw5usmi/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiamFja2llY2FvIiwiYSI6ImNpdTBqYXhmcjAxZ24ycGp3ZWZ1bTJoZ3QifQ.VytIrn5ZxVjtZjM15JPA9Q",
                   #attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
          #)%>%
            addProviderTiles("CartoDB.Positron")%>%
            setView(lng = -73.97, lat = 40.75, zoom = 12)  
            #addMarkers(data = run)


#set preference for runing environment
  
         # preference <-  reactive({
         #         r <- run
         #         if(input$park == TRUE){   
         #           r <- filter(r, Park == 1)
         #         } 
         #         if(input$riverside == TRUE){
         #           r <- filter(r, Riverside == 1)
         #         }
         #         if(input$dog == TRUE){
         #           r <- filter(r, Dog == 1)
         #         }
         #         if(input$drinkingfountain ==TRUE){   
         #           r <- filter(r, DrinkingFountain == 1)
         #         }
         #         
         #         
         #         if(input$safety == "Very Important to me!"){
         #           r<- filter(r, Safety == 5)
         #         }
         #         if(input$safety == "Let it be okay"){
         #           r<- filter(r, Safety == 3 | Safety == 4)
         #         }
         #         if(input$safety == "Not Care at all"){
         #           r<- filter(r, Safety <=5)
         #         }
         #         
         #         return(r)
         #  }) 
 


#Create icon for running spots 
 
             #runIcon <-
                 #makeIcon(
                    #iconUrl = "https://github.com/TZstatsADS/Fall2016-Proj2-grp7/blob/master/doc/icon/runner%20icon.png",
                    #iconWidth = 25, iconHeight = 25,
                    #iconAnchorX = 13, iconAnchorY = 13
                 #)
 
 
#add markers for running spots
             #observe({
                 #leafletProxy("map") %>% 
                   #clearMarkers() %>% 
                   #addMarkers(data = preference(), long = Long, lat =Lat, icon = runIcon, options(markerOptions(opacity = 0.9)), 
                              #popup = paste("*Neighborhood:",preference()$Neighborhood, "<br>", "*Name:", preference()$Name, "<br>")
                   #) 
             #})  

     })

})


   

