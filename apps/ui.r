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
library(shinyalert)
# Use a fluid Bootstrap layout

restaurant<- read.csv('../output/restaurant_final.csv')
type <- unique(as.character(restaurant$CUISINE))

ui <- dashboardPage(
  skin = "yellow",
                    dashboardHeader(title= "Day Planner"),
                    dashboardSidebar(
                      sidebarMenu(
                        id="tabs",
                        menuItem("Welcome",tabName = "Page_1",icon = icon("home")),
                        menuItem("Search", tabName = "Page_2",icon = icon("search-plus")),
                        menuItem("Feeling Lucky", tabName = "Page_3",icon = icon("laugh-wink"))
                      )
                    ),
                    dashboardBody(
                      tags$head(
                        tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
                      ),
                      tabItems(
                        
                        #Page 1 tab content
                        
                        tabItem(tabName = "Page_1",
                                
                              
                           
                                div(class = "Page_1",
                                
                                tags$head(
                                  # Include our custom CSS
                                  includeCSS("www/page1.css"),
                                  includeScript("www/click_hover.js")
                                  
                                ),
                                
                                align="center",
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                h1("Your Travel Suggestions in Manhattan",style="color:white;font-family: Times New Roman;font-size: 300%;font-weight: bold;"),
                                br(),
                                br(),
                                h3("Gourp 8 - Spring 2019",style="color:white;font-family: Times New Roman;font-size: 200%;font-weight: bold;"),
                                br(),
                                h5("Caihui Xiao",style="color:white;font-family: Times New Roman;font-size: 200%;font-weight: bold;"),
                                h5("Charlie Chen",style="color:white;font-family: Times New Roman;font-size: 200%;font-weight: bold;"),
                                h5("Weixuan Wu",style="color:white;font-family: Times New Roman;font-size: 200%;font-weight: bold;"),
                                h5("Xiaoxi Zhao",style="color:white;font-family: Times New Roman;font-size: 200%;font-weight: bold;"),
                                h5("Yuqiao Li",style="color:white;font-family: Times New Roman;font-size: 200%;font-weight: bold;")
                                
                                
                                
                                
                                
                        )
                                
                        ),
                        
                        # First tab content
                        tabItem(tabName = "Page_2",
                                ################# First Row #################
                                fluidRow(
                                  column(width = 1,
                                         style = "width:150px;display:inline-block;margin-right: 20px;margin-bottom:0px;margin-top:0px;padding-right:0px",
                                         selectInput("region1", "Choice 1:", c("Restaurant","Museum","Theatre","Gallery","Library"))
                                  ),
                                  column(width = 1,
                                         style = "width:150px;display:inline-block;margin-right: 0px;margin-bottom:0px;margin-top:0px;padding-right:0px",
                                         selectInput("region2", "Choice 2:", c("Restaurant","Museum","Theatre","Gallery","Library","NA"),"NA")
                                  ),
                                  column(width = 1,
                                         style = "width:150px;display:inline-block;margin-right: 0px;margin-bottom:0px;margin-top:0px;padding-right:0px",
                                         selectInput("region3", "Choice 3:", c("Restaurant","Museum","Theatre","Gallery","Library","NA"),"NA")
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
                                           #style = "width:500px;display:inline-block;margin-right:0px;margin-bottom:0px;margin-top:0px;padding-right:0px",
                                           tabsetPanel(type = "tabs",
                                                       tabPanel("Choice 1", dataTableOutput("table1")),
                                                       tabPanel("Choice 2", dataTableOutput("table2")),
                                                       tabPanel("Choice 3", dataTableOutput("table3"))
                                           )
                                    ),
                                    
                                    column(width = 5,
                                           style = "width:300px;display:inline-block;margin-right:0px;margin-bottom:0px;margin-top:0px;padding-right:0px",
                                           leafletOutput("map1", width = "250%", height = 550)
                                          
                                           
                                    )
                                  )
                                )
                        ),
                        
                        # Second tab content
                        tabItem(tabName = "Page_3",
                                tags$head(
                                  tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
                                ),
                                
                                div(id="pg3_header",
                                    #titlePanel("No idea at all?"),
                                    h3(HTML('&nbsp;'),HTML('&nbsp;'),HTML('&nbsp;'),"No idea at all?"),
                                    h4(HTML('&nbsp;'),HTML('&nbsp;'),HTML('&nbsp;'),"Just tell us where you are and how far you want to travel. We'll make a perfect plan for your day!")
                                ),
                              
                                
                                mainPanel(
                                  useShinyalert(),
                                  column(6,
                                         fluidRow(
                                           column(8,
                                          
                                           textInput("location",placeholder = "Enter Your Location",label = NULL, value="Current Location",width = "400px")),
                                           column(4,
                                                  
                                                  div(id="confirm", actionButton("submit","Confirm",icon("map-marker"), width  ="100px")))
                                         ),
                                         
                                         br(),p(),
                                         sliderInput("distance", "Please choose distance from you (in km):", min = 0, max = 20, value = 1, step= 0.1, width = "500px"),
                                         br(),
                                         actionButton("submit4", label="Feeling Lucky!",style="opacity:0.9",align="left"),
                                         br(),p(),br(),p(),
                                         
                                         div(id = "random_choice", 
                                             h4(textOutput("msg1")),br(),
                                             h4(textOutput("msg2")),br(),
                                             h4(textOutput("msg3"))
                                             )
                                         
                                         ),
                                  column(6,
                                         leafletOutput("map",width = "200%", height = 550),
                                         conditionalPanel('input.submit4 >0 && input.submit > 0',
                                                          absolutePanel(id="legend",
                                                                        class = "panel panel-default",
                                                                        
                                                                        
                                                                        top = 0, left = "auto", right = -278, bottom = "auto",
                                                                        width = 100, height = 150,
                                                                        
                                                                        h5("Select Features"),
                                                                        checkboxInput("Bus", label = "Bus",value= FALSE),
                                                                        checkboxInput("Subway",label="Subway",value = FALSE)
                                         )
                                )
                                
                                
                                
                                
                                
                                
                                
                              
                                           
                                           
                                           )
                                    
                                  )
                                )
                                  
                                  
                                  
                                )
                        )
                      )




                    
