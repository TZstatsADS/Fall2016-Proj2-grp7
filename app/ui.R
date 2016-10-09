library(shiny)
library(shinydashboard)
library(leaflet)
library(osrm)

dashboardPage(
  
  skin = 'purple',
  dashboardHeader(title = 'How New York Runs',
                  titleWidth = 300
                  ),
  
  dashboardSidebar(
 
    width = 300,
    ## Customize Header
    tags$head(tags$style(HTML('.main-header .logo {
                              font-family: "Avenir",Avenir, "Avenir", serif;
                              font-weight: bold;
                              font-size: 20px;
                              }
                              '))),
    
    ## Get user location
    tags$script('
      $(document).ready(function () {
                navigator.geolocation.getCurrentPosition(onSuccess, onError);
                
                function onError (err) {
                Shiny.onInputChange("geolocation", false);
                }
                
                function onSuccess (position) {
                setTimeout(function () {
                var coords = position.coords;
                console.log(coords.latitude + ", " + coords.longitude);
                Shiny.onInputChange("usergeolocation", true);
                Shiny.onInputChange("userlat", coords.latitude);
                Shiny.onInputChange("userlong", coords.longitude);
                }, 1100)
                }
                });
                '),
    tags$br(),
    div(strong('Starting Position', style = 'font-size:10.7pt'), style = 'line-height:200%;padding-left:11px'),
    sidebarSearchForm(textId = 'userlocation', buttonId = 'searchButton', 
                      icon = shiny::icon('location-arrow'), label = 'e.g.: Columbia Univeristy'),
    sliderInput(inputId = 'distance', label = 'Distance (Mile)', value = 3, min = 0, max = 15, step = 0.1),
    
    tags$hr(),
    radioButtons('airquality', 'Air Quality',
                 c('Very Important' = 5, 'Important' = 4, 'Fair' = 3, "Doesn't Matter" = 1), 'Important'),
    radioButtons('safety', 'Safety', 
                 c('Very Important' = 5, 'Important' = 4, 'Fair' = 3, "Doesn't Matter" = 1), 'Fair'),

    checkboxInput('park', 'Park & Garden', FALSE),
    checkboxInput('river', 'River & Pool', FALSE),
    checkboxInput('track', 'Running Track', FALSE),
    checkboxInput('drink', 'Drinking Fountain', FALSE),
    checkboxInput('dog', 'Dog Runs & Off-Leash Area', FALSE),
    tags$br(),
    div(actionButton('submit', 'Run', icon = shiny::icon('blind')), style = 'padding-left: 11px')
    
  ),
  
  dashboardBody(
    leafletOutput('map', width = '100%', height = 1000)
    
  )
)