
library(shiny)
library(maptools)
library(fields)
library(leaflet)
library(DT)
library(shinydashboard)

 
shinyUI(
        dashboardPage(skin = "yellow", 
                      dashboardHeader(title = "Running Manhattan"),
                      dashboardSidebar(tags$head(tags$style(HTML('.main-header .logo {font-family: "Britannic Bold",Britannic Bold, 
                                                                 "Britannic Bold", serif;font-weight: bold;font-size: 22px;}'
                                                            )
                                                 )
                                       ),
                  
                        sidebarMenu(
                          
                          menuItem("Running Map", tabName = "mapping", icon = icon("map")),
                          menuItem("Running Routes Planner", tabName = "routes", icon = icon("map-signs"))
                        )
                      ),
                      
                      dashboardBody(#div(class = "outer",
                                          #tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
                                          #tags$head(includeCSS("styles.css"))
                                         
                                    #),
                                     tags$head(tags$link(rel = "icon", type = "image/png", href = "favicon.png"),
                                     tags$title("Popular Running Spots")
                                              ),
                                    tabItems(
                                             tabItem(tabName = "mapping"
                                                     ,leafletOutput("map",height = 800)
                                           #,tabPanel(Title = "Mapping"  
                                                     #,div(class="outer",
                                                       #tags$head(
                                                            #includeCSS("styles.css")
                                                       #)   
                                                      #,absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                                               #top = 30, left = "auto", right = 35, width = 330, height = "auto",draggable = TRUE
                                                               #,checkboxInput("park", "GO Park", width = "90%")
                                                               #,checkboxInput("riverside","Go Riverside", width = "90%")
                                                               #,checkboxInput("dog", "Dog Friendly",width = "90%")
                                                               #,checkboxInput("drinkingfountain","Drinking Fountain Accessible", width = "90%")
                                                               #,selectInput("safety","Safety",SafetyLevel)
                                                               #,selectInput("airquality", "Airquality", AirQuality)
                                                               #,actionButton("MAPping"),
                                                               #,tags$style(type='text/css', "#recalc{horizontal-align:middle; position: absolute;left:35px;height: 43px; width:62%; font-size: 15px}")
                                                       #)
                                                       #)
                                              #)
                                           )
                                    )
                      ) 
          )
        
)
          

         
          
          
          
          
          
          
          
          
          
          
          
          
          
          