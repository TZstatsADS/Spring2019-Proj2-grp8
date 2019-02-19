# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).
library(datasets)

# Use a fluid Bootstrap layout
fluidPage(    
  
  # Give the page a title

  # Generate a row with a sidebar
  sidebarLayout(      
    
    # Define the sidebar with one input
    sidebarPanel(
      selectInput("region1", "Choice 1:", 
                  choices=c('NA','Museums','theatre','restaurant')),
      selectInput("region2", "Choice 2:", 
                  choices=c('NA','Museums','theatre','restaurant')),
      selectInput("region3", "Choice 3:", 
                  choices=c('NA','Museums','theatre','restaurant')),
      
      hr(),
      column(9, 
             br(),
             br(),
             dataTableOutput("table")  
      )
    ),
    
    # Create a spot for the barplot
    mainPanel(
    
      column(5,
             leafletOutput("map", width = "220%", height = 650)
      )
    )
    
  )
)
