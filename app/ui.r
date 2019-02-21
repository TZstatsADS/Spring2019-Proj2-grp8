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
                        menuItem("Page1",tabName = "prerequisite1",icon = icon("book")),
                        menuItem("Page2", tabName = "overview",icon = icon("dashboard")),
                        menuItem("Page3", tabName = "challenges",icon = icon("cogs"))
                      )
                    ),
                    dashboardBody(
                      tags$head(
                        tags$link(rel = "stylesheet", type = "text/css", href = "stylecssMouseExp.css")
                        
                        # tags$style(HTML(
                        # '.popover-title{
                        # color:black;
                        # font-size:16px;
                        # background-color: orange
                        # }'
                        # ))
                      ),
                      tabItems(
                        
                        #prerequiste tab content
                        
                        tabItem(tabName = "prerequisite1",
                                
                              
                           
                                
                                
                                div(style = "text-align:center",
                                    bsButton("nextbutton", "Explore", icon("wpexplorer"), size = "large",style = "warning"))
                                
                        ),
                        
                        # First tab content
                        tabItem(tabName = "overview",
                                #tags$a(href='http://stat.psu.edu/',   tags$img(src='logo.png', align = "left", width = 180)),

                                # div(style = "text-align:center",
                                #     bsButton("start", "GO", icon("bolt"), size = "large",style = "warning")),
                                fluidPage(    
                                  
                                  # Give the page a title
                                  
                                  # Generate a row with a sidebar
                                  sidebarLayout(      
                                    
                                    # Define the sidebar with one input
                                    sidebarPanel(
                                      selectInput("region1", "Choice 1:", 
                                                  choices=c('Restaurant','NA','Museums','Theatre')),
                                      selectInput("region2", "Choice 2:", 
                                                  choices=c('NA','Museums','Theatre','Restaurant')),
                                      selectInput("region3", "Choice 3:", 
                                                  choices=c('NA','Museums','Theatre','Restaurant')),
                                      conditionalPanel("input.region1 == 'Restaurant' || input.region2 == 'Restaurant' || input.region3 == 'Restaurant'" ,
                                                       selectInput('type1','Restaurant Type',c("ALL",type))),
                                      
                                      hr(),
                                      column(9, 
                                             br(),
                                             br(),
                                             tabsetPanel(type = "tabs",
                                                         tabPanel("Choice 1", dataTableOutput("table1")),
                                                         tabPanel("Choice 2", dataTableOutput("table2")),
                                                         tabPanel("Choice 3", dataTableOutput("table3"))
                                             )
                                             
                                      )
                                    ),
                                    
                                    
                                    
                                    
                                    # Create a spot for the barplot
                                    mainPanel(
                                      column(width=1, 
                                             actionButton("button2",label="Reset Map" 
                                                          #,style="padding:12px; font-size:80%;color: #fff; background-color: #337ab7; border-color: #2e6da4"
                                             )),
                                      
                                      leafletOutput("map1", width = "200%", height = 400)
                                    )
                                  )
                                  
                                )
                                
                             
                                
                                
                        ),
                        
                        # Second tab content
                        tabItem(tabName = "challenges",
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
                                    verbatimTextOutput("action"),
                                    verbatimTextOutput("errorput"),
                                    verbatimTextOutput("locationin"),
                                    column(12,leafletOutput("map"),
                                           conditionalPanel('input.submit4 >0 && input.submit > 0',
                                                            absolutePanel(id="legend",
                                                                          class = "panel panel-default",
                                                                          col = 'red',
                                                                        
                                                                         
                                                                          top = 0, left = "auto", right = 0, bottom = "auto",
                                                                          width = 100, height = 150,
                                                                          
                                                                          h5("Select Features"),
                                                                          checkboxInput("Bus", label = "Bus",value= FALSE),
                                                                          checkboxInput("Subway",label="Subway",value = FALSE))
                                                            
                                                            
                                           )
                                           
                                           
                                           ),
                                    verbatimTextOutput("c1"),
                                    verbatimTextOutput("c2"),
                                    
                                    verbatimTextOutput("target1"),
                                    verbatimTextOutput("target3"),
                                    verbatimTextOutput("target2")
                                  )
                                )
                        
                                  
                                  
                                  
                              
                  
                                  
                                  
                                  
                                )
                        )
                      )
)



                    
