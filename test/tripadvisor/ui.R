
library(shiny)
library(leaflet)
library(leaflet.extras)
library(rebird)
library(geosphere)
library(ggmap)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Plan your day"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(id="control1",fixed = T,draggable = T,class = "panel panel-default",top = 80,
                 
                 left = 55, right = "auto", bottom = "auto",
                 
                 width = 280, height = 550,
                 
                 textInput("location",label = h3("Enter Your Location"),"Current Location"),
                 actionButton("submit","Mark Your Location",icon("map-marker")),
                 sliderInput("distance", "Distance From You (in km)", min = 0, max = 20, value = 1, step= 0.1),
                 actionButton("submit4", label="Go!",style="opacity:0.8",align="left"),
                 absolutePanel(id="legend",
                               fixed = TRUE,
                               draggable = TRUE, top = 140, left = "auto", right = 80, bottom = "auto",
                               width = 125, height = 215,
                               
                               h5("Select Features"),
                               checkboxInput("Bus", label = "Bus",value= FALSE),
                               checkboxInput("Subway",label="Subway",value = FALSE)
                               
                 )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      verbatimTextOutput("action"),
      verbatimTextOutput("errorput"),
      verbatimTextOutput("locationin"),
      leafletOutput("map"),
      verbatimTextOutput("c1"),
      verbatimTextOutput("c2"),
      
      verbatimTextOutput("target1"),
      verbatimTextOutput("target3"),
      verbatimTextOutput("target2")
    )
  )
))
