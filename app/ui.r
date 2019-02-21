# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).
library(shiny)
library(shinydashboard)
library(leaflet)
library(ggplot2)
library(shinyjs)
library(shinydashboard)
library(shiny)
library(shinyBS)
library(shinyWidgets)
library(leaflet.extras)
library(rebird)
library(geosphere)
library(ggmap)
# Use a fluid Bootstrap layout

restaurant<- read.csv('../output/restaurant_new.csv')
type <- unique(as.character(restaurant$TYPE))

ui <- dashboardPage(skin = "yellow",
                    dashboardHeader(title= "Travel Suggestion"),
                    dashboardSidebar(
                      sidebarMenu(
                        id="tabs",
                        menuItem("Page1",tabName = "Page_1",icon = icon("book")),
                        menuItem("Page2", tabName = "Page_2",icon = icon("dashboard")),
                        menuItem("Page3", tabName = "Page_3",icon = icon("cogs"))
                      )
                    ),
                    dashboardBody(
                      tags$head(
                        tags$link(rel = "stylesheet", type = "text/css", href = "stylecssMouseExp.css")
                      ),
                      tabItems(
                        
                        #Page 1 tab content
                        
                        tabItem(tabName = "Page_1",
                                
                              
                           
                                
                                
                                div(style = "text-align:center",
                                    bsButton("nextbutton", "Explore", icon("wpexplorer"), size = "large",style = "warning"))
                                
                        ),
                        
                        # First tab content
                        tabItem(tabName = "Page_2",
                                ################# First Row #################
                                fluidRow(
                                  column(width = 1,
                                         style = "width:150px;display:inline-block;margin-right: 20px;margin-bottom:0px;margin-top:0px;padding-right:0px",
                                         selectInput("region1", "Choice 1:", choices=c('Restaurant','NA','Museums','Theatre'))
                                  ),
                                  column(width = 1,
                                         style = "width:150px;display:inline-block;margin-right: 0px;margin-bottom:0px;margin-top:0px;padding-right:0px",
                                         selectInput("region2", "Choice 2:", choices=c('NA','Museums','Theatre','Restaurant'))
                                  ),
                                  column(width = 1,
                                         style = "width:150px;display:inline-block;margin-right: 0px;margin-bottom:0px;margin-top:0px;padding-right:0px",
                                         selectInput("region3", "Choice 3:", choices=c('NA','Museums','Theatre','Restaurant'))
                                  ),
                                  column(width = 1,
                                         style = "width:150px;display:inline-block;margin-right: 0px;margin-bottom:0px;margin-top:0px;padding-right:0px",
                                         conditionalPanel(
                                           "input.region1 == 'Restaurant' || input.region2 == 'Restaurant' || input.region3 == 'Restaurant'" ,
                                           selectInput('type1','Restaurant Type',c("ALL",type))
                                         )
                                  ),
                                  column(width=1, 
                                         style = "margin-top:25px;display:inline-block;margin-left:500px;",
                                         actionButton("button2",label="Reset Map") 
                                  )
                                ),
                                
                                ################ Second Row ###################
                                mainPanel(
                                  fluidRow(
                                    column(8,
                                           style = "width:500px;display:inline-block;margin-right:0px;margin-bottom:0px;margin-top:0px;padding-right:0px",
                                           tabsetPanel(type = "tabs",
                                                       tabPanel("Choice 1", dataTableOutput("table1")),
                                                       tabPanel("Choice 2", dataTableOutput("table2")),
                                                       tabPanel("Choice 3", dataTableOutput("table3"))
                                           )
                                    ),
                                    
                                    column(width = 4,
                                           leafletOutput("map1", width = "260%", height = 550)
                                           
                                    )
                                  )
                                )
                        ),
                        
                        # Second tab content
                        tabItem(tabName = "Page_3",
                                 titlePanel("Plan your day"),
                                
                                # Sidebar with a slider input for number of bins 
                                sidebarLayout(
                                  sidebarPanel(id="control1",fixed = T,draggable = T,class = "panel panel-default",top = 80,
                                               
                                               left = 55, right = "auto", bottom = "auto",
                                               
                                               width = 280, height = 550,
                                               
                                               textInput("location",label = h3("Enter Your Location"),"Current Location"),
                                               actionButton("submit","Mark Your Location",icon("map-marker")),
                                               sliderInput("distance", "Distance From You (in km)", min = 0, max = 20, value = 1, step= 0.1),
                                               actionButton("submit4", label="Go!",style="opacity:0.8",align="left")
                                           
                                  ),
                                  
                                  
                                  # Show a plot of the generated distribution
                                  mainPanel(
                                    verbatimTextOutput("errorput"),
                                    column(4,verbatimTextOutput("c1"),
                                           verbatimTextOutput("c2"),
                                           
                                           verbatimTextOutput("target1"),
                                           verbatimTextOutput("target3"),
                                           verbatimTextOutput("target2")),
                                    column(8,leafletOutput("map",width = "160%", height = 400),
                                           conditionalPanel('input.submit4 >0 && input.submit > 0',
                                                            absolutePanel(id="legend",
                                                                          class = "panel panel-default",
                                                                        
                                                                         
                                                                          top = 0, left = "auto", right = -278, bottom = "auto",
                                                                          width = 100, height = 150,
                                                                          
                                                                          h5("Select Features"),
                                                                          checkboxInput("Bus", label = "Bus",value= FALSE),
                                                                          checkboxInput("Subway",label="Subway",value = FALSE))
                                                            
                                                            
                                           )
                                           
                                           
                                           )
                                    
                                  )
                                )
                                  
                                  
                                  
                                )
                        )
                      )
)



                    
