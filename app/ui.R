library(shiny)
library(shinydashboard)
library(leaflet)
library(osrm)
#drop-downs
SafetyLevel <- c("Very Important to me!", 
                 "Let it be okay",
                 "Not Care at all" 
)
AirQuality <- c("Very Important to me!", 
                "Let it be okay",
                "Not Care at all" 
)

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
    
    sidebarMenu(id = 'sidebarmenu', 
                menuItem('Route Planner', tabName = 'routeplan', icon = shiny::icon('street-view'), 
                         div(strong('Starting Position', style = 'font-size:10.7pt'), style = 'line-height:200%;padding-left:11px'),
                         sidebarSearchForm(textId = 'userlocation', buttonId = 'searchButton', 
                                           icon = shiny::icon('search'), label = 'e.g.: Columbia Univeristy, New York'),
                         checkboxInput('currentlocation', 'Use Current Location', F),
                         sliderInput(inputId = 'distance', label = 'Distance (Mile)', value = 3, min = 0, max = 15, step = 0.1),
                         
                         tags$hr(),
                         radioButtons('airquality', 'Air Quality',
                                      c('Very Important' = 5, 'Important' = 4, 'Fair' = 3, "Doesn't Matter" = 0), 'Important'),
                         radioButtons('safety', 'Safety', 
                                      c('Very Important' = 5, 'Important' = 4, 'Fair' = 3, "Doesn't Matter" = 0), 'Fair'),
                         
                         checkboxInput('park', 'Park & Garden', FALSE),
                         checkboxInput('river', 'River & Pool', FALSE),
                         checkboxInput('track', 'Running Track', FALSE),
                         checkboxInput('drink', 'Drinking Fountain', FALSE),
                         checkboxInput('dog', 'Dog Runs & Off-Leash Area', FALSE),
                         div(actionButton('submit', 'Run', icon = shiny::icon('blind'), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"), style = 'padding-left: 11px'),
                         tags$style(type='text/css', "#submit{height: 40px; width:62%; font-size: 16px}"),
                         tags$br()
                ),
                menuItem("Running Map", tabName = "mapping", icon = icon("map")
                         ,checkboxInput("park", "GO Park", width = "90%", value = TRUE)
                         ,checkboxInput("riverside","Go Riverside & Pool", width = "90%")
                         ,checkboxInput("dog", "Dog Friendly",width = "90%", value = TRUE)
                         ,checkboxInput("drinkingfountain","Drinking Fountain", width = "90%")
                         ,selectInput("safety","Safety",SafetyLevel, selected = "Let it be okay")
                         ,selectInput("airquality", "Air Quality", AirQuality)
                )
    )
    
    
    ),
  
  dashboardBody(
    tabItems (
              tabItem(tabName='routeplan',
                      h2("Map 1")),
              tabItem(tabName='mapping',
                      h2("Shujin map"))
    )
    #tabItem(tabName = 'routeplan',
            #leafletOutput('map', width = '100%', height = 1000)
            
    #),
    
    #tabItem(tabName = "mapping",
            #leafletOutput("map2",height = 800))
  )
)
