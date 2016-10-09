library(sp)


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
        'https://api.mapbox.com/styles/v1/mapbox/streets-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1Ijoiam9leXRoZWRvZyIsImEiOiJjaW41MW5mNmYwY2NrdXJra2g4bmR3Y3dhIn0.5DzFBRvdn_9OHFmDFYwFmw'
      )%>%
      addMarkers(data=points(),lat = ~lat,lng = ~lon)%>%
      addPolylines(data = routes())
      
      
  })
})

#shinyApp(ui =ui,server=server)
#1.get location.


