
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
                  menuItem("Running Routes Planner", tabName = "routes", icon = icon("map-signs")),
                  
                  menuItem("Running Map", tabName = "mapping", icon = icon("map")
                           ,checkboxInput("park2", "GO Park", width = "90%", value = TRUE)
                           ,checkboxInput("riverside","Go Riverside & Pool", width = "90%")
                           ,checkboxInput("dog2", "Dog Friendly",width = "90%", value = TRUE)
                           ,checkboxInput("drinkingfountain","Drinking Fountain", width = "90%")
                           ,selectInput("safety2","Safety",c('Very Important' = 5,  'Fair' = 3, "Doesn't Matter" = 0), 5)
                           ,selectInput("airquality2", "Air Quality",  c('Very Important' = 5,  'Fair' = 3, "Doesn't Matter" = 0), 3)
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
















