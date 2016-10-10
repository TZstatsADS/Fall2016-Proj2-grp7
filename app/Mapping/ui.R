
library(shiny)
library(maptools)
library(fields)
library(leaflet)
library(DT)
library(shinydashboard)

#drop-downs
SafetyLevel <- c("Very Important to me!", 
                 "Let it be okay",
                 "Not Care at all" 
)
AirQuality <- c("Very Important to me!", 
                "Let it be okay",
                "Not Care at all" 
)
 
shinyUI(
        dashboardPage(skin = "yellow", 
                      dashboardHeader(title = "Running Manhattan"),
                      dashboardSidebar(tags$head(tags$style(HTML('.main-header .logo {font-family: "Britannic Bold",Britannic Bold, 
                                                                 "Britannic Bold", serif;font-weight: bold;font-size: 22px;}'
                                                            )
                                                 )
                                       ),
                  
                          sidebarMenu(
                          menuItem("Running Map", tabName = "mapping", icon = icon("map")
                                   ,checkboxInput("park", "GO Park", width = "90%", value = TRUE)
                                   ,checkboxInput("riverside","Go Riverside", width = "90%")
                                   ,checkboxInput("dog", "Dog Friendly",width = "90%", value = TRUE)
                                   ,checkboxInput("drinkingfountain","Drinking Fountain Accessible", width = "90%")
                                   ,selectInput("safety","Safety",SafetyLevel, selected = "Let it be okay")
                                   ,selectInput("airquality", "Airquality", AirQuality)),
                          menuItem("Running Routes Planner", tabName = "routes", icon = icon("map-signs"))
                          )
                      ),
                      dashboardBody(#div(class = "outer",
                                          #tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
                                          #tags$head(includeCSS("styles.css"))
                                         
                                    #),
                                     tags$head(tags$link(rel = "icon", type = "image/png", href = "favicon.png"),
                                     tags$title("Popular Running Spots")),
                                     
                                             tabItem(tabName = "mapping",
                                                     leafletOutput("map",height = 800)
                                               
                                              )
                                    
                      ) 
          )
        
)
          

         
          
          
          
          
          
          
          
          
          
          
          
          
          
          