
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
                  menuItem("Running Routes Planner", tabName = "routes", icon = icon("map-signs")),
                  
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
           
                  tabItem(tabName = "mapping",
                          leafletOutput("map2",height = 800)),
                  
                  tabItem(tabName = "Running Routes Planner"
                          )
                )
                 
  )
  
  )
















