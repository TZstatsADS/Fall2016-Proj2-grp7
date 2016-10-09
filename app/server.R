library(sp)
library(cartography)

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
  
  points <- eventReactive(input$submit,{
    var <- cbind(1:5,rnorm(5)*0.01 + -73.96, rnorm(5)*0.01 + 40.8)
    colnames(var) <- c("id","lon","lat")
    as.data.frame(var)
  }, ignoreNULL = F)
  
  routes<-eventReactive(
    input$submit,
    {
      points <- isolate(points())
      routes<- osrmTrip(points)
      routes <-routes[[1]]$trip
      routes
    }, ignoreNULL = FALSE
  )
  
  
  output$map <- renderLeaflet({
    
    leaflet() %>%
      
      addTiles(
        #urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        #attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      )%>%
      addMarkers(data=points(),lat = ~lat,lng = ~lon)%>%
      addPolylines(data = routes())
      
      
  })
})

#shinyApp(ui =ui,server=server)
#1.get location.


