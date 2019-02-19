

museum<-na.omit(read.csv("museums.csv"))
theatre<-read.csv('theatre.csv')
restaurant<- read.csv('restaurant_new.csv')
# Define a server for the Shiny app
function(input, output) {
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles('Esri.WorldTopoMap') %>%
      setView(lng = -73.971035, lat = 40.775659, zoom = 12) %>%
      addMarkers(data=restaurant,
                 lng=restaurant$LON,
                 lat=restaurant$LAT,
                 clusterOptions=markerClusterOptions(),
                 group="housing_cluster"
      )
  })
  
  # Fill in the spot we created for a plot
  output$table <- renderDataTable({
    
    if (input$region1 == 'Museums'){
      print(museum[,1:3])
      
    }
    else if(input$region1 == 'theatre'){
      print(theatre)
      
    }
    else if(input$region1 == 'restaurant') {
      print(restaurant)
      
    }
    
   
  })
}
