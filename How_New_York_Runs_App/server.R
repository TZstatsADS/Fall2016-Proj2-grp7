library(shiny)
library(shinydashboard)
library(leaflet)
# library(osrm)
library(sp)
library(data.table)
library(ggmap)
library(RColorBrewer)
library(dplyr)
library(ggplot2)
library(maps)
library(mapdata)

Meander <- function(start_lon,start_lat,end_lon,end_lat,running_distance_in_mile,Nodes,Scores)
{
  library(stats)
  library(pryr)
  library(leaflet)
  library(maps)
  # library(osrm)
  library(geosphere)
  #  1. Longi; 2. Lati;
  node_info=matrix(0,nrow=length(Scores)+2,ncol=3)
  
  node_info[1:length(Scores),]=c(Nodes[,1],Nodes[,2],Scores)
  num=dim(node_info)[1]
  node_info[num-1,]=c(start_lon,start_lat,0)
  node_info[num,]=c(end_lon,end_lat,0)
  start_node=num-1;
  if(node_info[num,1]==-1) 
  {
    end_node=start_node;
    num=num-1
  }
  ############## Prep ###################    
  distance=distm(node_info[,1:2])*1.25
  close_neib=t(apply(distance,2,order))
  sorted_dist=t(apply(distance,2,sort))
  nodes_passed=array(FALSE,dim=num)
  bestroute=array(0,dim=num+1)
  bestscore=-9999
  finaldist=0
  ################# Search ##################  
  a=Sys.time()
  route=array(0,dim=num)
  g=environment()
  findroute=function(x,d,tt) # x: current position; d: distance remains; tt: how many nodes visited, does not include x
  {
    b=Sys.time()
    if((b-a)<10){                               # Change stop timer here
      if(x!=end_node) g$nodes_passed[x]=TRUE
      g$route[tt+1]=x
      if ((x==end_node) & (tt>0))
      {
        g$score=sum(node_info[route,3])
        if(g$score>g$bestscore)
        {
          g$bestscore=g$score
          #print(g$bestscore)
          g$bestroute=g$route
          g$bestroute[num+1]=tt+1
          g$finaldist=running_distance_in_mile*1609-d
        }
      }
      else {
        for(i in 2:num)
        {
          j=close_neib[x,i]
          if((distance[x,j]+distance[j,end_node])>d) break
          else if(g$nodes_passed[j]==FALSE & j!=end_node)
          {
            findroute(j,d-distance[x,j],tt+1)
          }
        }
        if(distance[x,end_node]<=d) findroute(end_node,d-distance[x,end_node],tt+1)
      }
      g$nodes_passed[x]=FALSE
    }
  }
  
  findroute(start_node,running_distance_in_mile*1609,0)
  
  stops=bestroute[length(bestroute)]
  bestroute=bestroute[1:stops]  
  print(bestroute)
  print(bestscore)
  
   route_in_osm=matrix(node_info[start_node,1:2],ncol=2)
#   for (i in 2:stops)
#   {
#     Akke=osrmRoute(c(1,node_info[bestroute[i-1],1],node_info[bestroute[i-1],2]),c(2,node_info[bestroute[i],1],node_info[bestroute[i],2]))
#     route_in_osm=rbind(route_in_osm,as.matrix(Akke),node_info[bestroute[i],1:2])
#   }
   return(list(bestroute,route_in_osm))
}



shinyServer(function(input, output){
  
  ## Get user location
  output$userlat <- renderPrint({
    input$userlat
  })
  
  output$userlong <- renderPrint({
    input$userlong
  })
  
  output$usergeolocation <- renderPrint({
    input$usergeolocation
  })
  
  # get node data
  nodedata <- read.csv('map_point_withAddress_rescaleAQI.csv')
  run = nodedata
  
  #points <- eventReactive(input$submit,{
  #var <- cbind(1:5,rnorm(5)*0.01 + -73.96, rnorm(5)*0.01 + 40.8)
  #colnames(var) <- c("id","lon","lat")
  #as.data.frame(var)
  #}, ignoreNULL = F)
  
  routes<-eventReactive(
    input$submit,
    {
      #print(input$userlocation)
      start_lat <- input$userlat
      start_lon <-  input$userlong
      #print(start_lat)
      #print(start_lon)
      
      if(isolate(input$userlocation) != '') {
        
        address <-isolate(input$userlocation)
        
        geocode <- geocode(address)
        print(geocode)
        start_lat <- as.numeric(geocode$lat)
        start_lon <- as.numeric(geocode$lon)
        
        
      }
      
      
      
      distance <- input$distance
      #print(distance)
      nodes <- nodedata[, 2:3]
      
      DT <- as.data.table(nodedata)
      print(class(input$airquality))
      w1 <- 1/(mean(DT$Park))*1000
      w2 <- 1/(mean(DT$Dog))*1000
      w3 <- 1/(mean(DT$Riverside))*1000
      w4 <- 1/(mean(DT$DrinkingFountains))*1000
      w5 <- 1/(mean(DT$Airquality))*200
      w6 <- 1/(mean(DT$RunningTrack))*1000
      w7 <- 1/(mean(DT$Safety))*200
      score <- DT[, scores := w1*Park*input$park + w2*Dog*input$dog + w3*Riverside*input$river + w4*DrinkingFountains*input$drink + w5*Airquality* as.numeric(input$airquality) + w6*RunningTrack*input$track + w7*Safety*as.numeric(input$safety)] 
      scores <- score[, scores]
      #points <- isolate(points())
      #routes<- osrmTrip(points)
      #routes <-routes[[1]]$trip
      #print(score)
      #routes
      routes <- Meander(start_lon, start_lat, -1, -1, distance, as.matrix(nodes[,c(2,1)]), scores)
      planB=as.matrix(0,nrow=500,ncol=2)
      planB=rbind(c(start_lon,start_lat),nodes[routes[[1]][2:(length(routes[[1]])-1)],c(2,1)],c(start_lon,start_lat))
      as.matrix(planB)
      
    }, ignoreNULL = FALSE
  )
  
  print(isolate(routes()))
  
  output$map <- renderLeaflet({
    
    leaflet() %>%
      
      addTiles(
        'https://api.mapbox.com/styles/v1/mapbox/streets-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1Ijoiam9leXRoZWRvZyIsImEiOiJjaW41MW5mNmYwY2NrdXJra2g4bmR3Y3dhIn0.5DzFBRvdn_9OHFmDFYwFmw'
      )%>%
      setView(lng = -73.97396, lat =40.78870, zoom =15)%>%
      
     # addMarkers(data=points(),lat = ~lat,lng = ~lon)%>%
      addPolylines(data=routes())
    
    
  })
  ############Menu Item 2
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
      rrr = filter(rrr, Airquality > 0 )
    }
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
      rrr = filter(rrr, Airquality > 0 )
    }
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

  
  
})

#shinyApp(ui =ui,server=server)
#1.get location.
