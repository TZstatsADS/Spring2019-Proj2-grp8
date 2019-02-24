library(geosphere)
library(ggmap)
library(maptools)
library(leaflet)

restaurant<-read.csv("../output/restaurant_final.csv")
type <- unique(as.character(restaurant$CUISINE))
namedata<-c("Museum","Theatre","Gallery","Library")
Gallery<-na.omit(read.csv("../output/Gallery.csv",header=T))
Library<-na.omit(read.csv("../output/Library.csv",header=T))
Museum<-na.omit(read.csv("../output/Museum.csv",header=T))
Theatre<-na.omit(read.csv("../output/Theater.csv",header=T))
all_data<-list(Gallery=Gallery,Library=Library,Museum=Museum,Restaurant=restaurant,Theatre=Theatre)
register_google("AIzaSyA8OuCvy04PC3N-K9y6DdEc32hUpNyUrl8")
load("../output/sub.station.RData")
load("../output/bus.stop.RData")
source("../lib/global.R")
# Define a server for the Shiny app
#all_data1 = list(museum = museum,theatre = theatre, restaurant = restaurant)
#namedata1 = c('museum','theatre','restaurant')
function(input, output) {
  
  
  #################Clear Choices############
  observeEvent(input$button2,{
    proxy<-leafletProxy("map1")
    proxy %>%
      setView(lng = -73.971035, lat = 40.775659, zoom = 12) 
    # %>%
    #   removeMarker(layerId="1") %>%
    #   addMarkers(data=housing,
    #              lng=~lng,
    #              lat=~lat,
    #              clusterOptions=markerClusterOptions(),
    #              group="housing_cluster")
    
  })
  ###map
  output$map1 <- renderLeaflet({
    leaflet() %>%
      addProviderTiles('Esri.WorldTopoMap') %>%
      setView(lng = -73.971035, lat = 40.775659, zoom = 12) %>%
      addMarkers(data=restaurant,
                 lng=restaurant$LON,
                 lat=restaurant$LAT,
                 clusterOptions=markerClusterOptions(),
                 icon=list(iconUrl=paste('icon/',"Restaurant",'.png',sep = ""),iconSize=c(20,20)),
                 popup=paste("Name:",a(restaurant$NAME, href = restaurant$URL),"<br/>",
                             "Tel:",restaurant$TEL,"<br/>",
                             "Price:",restaurant$PRICE,"<br/>",
                             "Rating:",restaurant$RATING,"<br/>",
                             "GRADE:",restaurant$GRADE,"<br/>",
                             "Address:",restaurant$ADDRESS),
                 group="housing_cluster"
      )
  })
  
  observeEvent(input$region1,{
    leafletProxy("map1") %>%
      showGroup(input$region1)

  })    
  
  observeEvent(input$region2,{
    if(input$region2 == "NA" ){leafletProxy("map1")%>%showGroup(input$region1)}
    else {leafletProxy("map1")%>%
        hideGroup(c('museum','theatre','restaurant','American', 'Asian', 'Chinese' ,'Dessert', 'European', 'French','Italian', 'Mexcian' ,'Other', 'QuickMeal' , 'Seafood'))%>%
        showGroup(c(input$region2))}
  })
  
  
  
  observeEvent(input$region3,{
    if("NA" == input$region3){leafletProxy("map1")%>%showGroup(c(input$region1,input$region2))}
    else {leafletProxy("map1")%>%
        hideGroup(c('museum','theatre','restaurant','American', 'Asian', 'Chinese' ,'Dessert', 'European', 'French','Italian', 'Mexcian' ,'Other', 'QuickMeal' , 'Seafood'))%>%
        showGroup(c(input$region3))}
  })
  
  observeEvent(input$type1,{
    if(input$type1 == 'ALL'){leafletProxy("map1")%>%showGroup(c(input$region1,input$region2,input$region2))}
    else {leafletProxy("map1")%>%
        hideGroup(c('museum','theatre','restaurant','American', 'Asian', 'Chinese' ,'Dessert', 'European', 'French','Italian', 'Mexcian' ,'Other', 'QuickMeal' , 'Seafood'))%>%
        showGroup(c(input$type1))}
    print(input$type1)
  })
  
 # showStatus = reactive({
#    if (is.null(input$map_bounds)){
#      return ("1")
#    } else {
#      if (input$map_zoom<16){
#        return ("2")
#      } else {
#        return ("3")
#      }
#    }
#  })
  
  # get the museum data in the bounds
  MuseumInBounds <- reactive({
    if (is.null(input$map1_bounds))
      return(Museum[FALSE,])
    bounds <- input$map1_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    return(
      subset(Museum,
             LAT>= latRng[1] & LAT <= latRng[2] &
               LON >= lngRng[1] & LON <= lngRng[2])
    )
  })
  
  # get the theatre data in the bounds
  TheatreInBounds <- reactive({
    if (is.null(input$map1_bounds))
      return(Theatre[FALSE,])
    bounds <- input$map1_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    return(
      subset(Theatre,
             LAT>= latRng[1] & LAT <= latRng[2] &
               LON >= lngRng[1] & LON <= lngRng[2])
    )
  })
  
  # get the restaurant data in the bounds
  RestaurantInBounds <- reactive({
    if (is.null(input$map1_bounds))
      return(restaurant[FALSE,])
    bounds <- input$map1_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    return(
      subset(restaurant,
             LAT>= latRng[1] & LAT <= latRng[2] &
               LON >= lngRng[1] & LON <= lngRng[2])
    )
  })
  
  #subset dataset
  observe({
    museum_subset = MuseumInBounds()
    theatre_subset = TheatreInBounds()
    restaurant_subset = RestaurantInBounds()
    
    if (nrow(museum_subset) != 0){
      Museum = museum_subset
    }
    
    output$table1 <- renderDataTable({
      
      if (input$region1 == 'Museums'){
        print(Museum[,1:3])
        
      }
      else if(input$region1 == 'Theatre'){
        print(Theatre)
        
      }
      else if(input$region1 == 'Restaurant') {
        if (input$type1 == 'ALL'){
          print(restaurant)
        }
        else{
          print(restaurant[restaurant$CUISINE == as.character(input$type1),])
        }
        
      }
    }) 
    output$table2 <- renderDataTable({
      
      if (input$region2 == 'Museums'){
        print(Museum[,1:3])
        
      }
      else if(input$region2 == 'Theatre'){
        print(Theatre)
        
      }
      else if(input$region2 == 'Restaurant') {
        if (input$type1 == 'ALL'){
          print(restaurant)
        }
        else{
          print(restaurant[restaurant$CUISINE == as.character(input$type1),])
        }      
      }
    })
    output$table3 <- renderDataTable({
      
      if (input$region3 == 'Museums'){
        print(Museum[,1:3])
        
      }
      else if(input$region3 == 'Theatre'){
        print(Theatre)
        
      }
      else if(input$region3 == 'Restaurant') {
        if (input$type1 == 'ALL'){
          print(restaurant)
        }
        else{
          print(restaurant[restaurant$CUISINE == as.character(input$type1),])
        }        
      }
    })
    })
 
  # Fill in the spot we created for a plot
  # output$table1 <- renderDataTable({
  # 
  #   if (input$region1 == 'Museums'){
  #     print(Museum[,1:3])
  # 
  #   }
  #   else if(input$region1 == 'Theatre'){
  #     print(Theatre)
  # 
  #   }
  #   else if(input$region1 == 'Restaurant') {
  #     if (input$type1 == 'ALL'){
  #       print(restaurant)
  #     }
  #     else{
  #       print(restaurant[restaurant$CUISINE == as.character(input$type1),])
  #     }
  # 
  #   }
  #   })
  # output$table2 <- renderDataTable({
  #  
  #  if (input$region2 == 'Museums'){
  #    print(Museum[,1:3])
  #    
  #  }
  #  else if(input$region2 == 'Theatre'){
  #    print(Theatre)
  #    
  #  }
  #  else if(input$region2 == 'Restaurant') {
  #    if (input$type1 == 'ALL'){
  #      print(restaurant)
  #    }
  #    else{
  #      print(restaurant[restaurant$CUISINE == as.character(input$type1),])
  #    }      
  #  }
  #})
  #  output$table3 <- renderDataTable({
  #    
  #    if (input$region3 == 'Museums'){
  #      print(Museum[,1:3])
  #      
  #    }
  #    else if(input$region3 == 'Theatre'){
  #      print(Theatre)
  #      
  #    }
  #    else if(input$region3 == 'Restaurant') {
  #      if (input$type1 == 'ALL'){
  #        print(restaurant)
  #     }
  #      else{
  #        print(restaurant[restaurant$CUISINE == as.character(input$type1),])
  #      }        
  #    }
  #  })
    
    observeEvent(input$submit,{
      if(input$location=="Current Location"){
        coord<-getlatlng()
        lat<-coord[1]
        long<-coord[2]
        output$map<-renderLeaflet(
          {    map <- leaflet() %>% addTiles()
          
          map <- addControlGPS(map, options = gpsOptions(position = "topleft", activate = TRUE, 
                                                         autoCenter = TRUE, maxZoom = 10, 
                                                         setView = TRUE))
          activateGPS(map)
          
          
          })
        output$action=renderPrint({coord})
        
      }else{
        coord<-geocode(input$location)
        output$action=renderPrint({coord})
        lat<-as.numeric(coord[2])
        long<-as.numeric(coord[1])
        if(is.na(lat)&is.na(long)){ 
          output$errorput<-renderText("Please enter a valid address")
        }else{
          output$map<-renderLeaflet(
            {    map<-leaflet() %>%  addTiles()%>%
              addMarkers(lng=long,lat=lat)
            
            
            })
        }
      }
      
      # random choice
      
      
      output$locationin<-renderText(input$location)
      observeEvent(input$submit4,{
        index<-sample(1:4,2,replace=F)
        choice<-c("Theatre","Museum","Gallery","Library","Restaurant")
        choice1<-choice[index[1]]
        choice2<-choice[index[2]]
        index[3]<-length(choice)
        choice3<-choice[index[3]]
        
        
        data_candidate<-all_data[c(choice1,choice2,choice3)]
        
        ##Get candidates according to the radius:
        data_select<-lapply(data_candidate,get_candidate,Lon0=long,Lat0=lat,r=input$distance*1000)
        
        targetplan<-lapply(data_select,randomchoice)
        target1 <- as.character(targetplan[[1]][1,"NAME"])
        target2 <- as.character(targetplan[[2]][1,"NAME"])
        target3 <- as.character(targetplan[[3]][1,"NAME"])
        
        output$msg1 = renderText({
          paste("Interested in ", {choice1}, " and ", {choice2}, "? ", sep="")
        })
        
        output$msg2 = renderText({
          paste("Why not spend your morning in ", {target1}, ", enjoy the lunch at ",
                {target3}, ", and finish your day at ", {target2}, "?", sep="")
        })
        
        output$msg3 = renderText({
          paste("Click the icons on the map for more information. Not satisfied? Click
                Feeling Lucky again!", sep="")
        })
        
        
        leafletProxy("map")%>%
          clearMarkerClusters()
        
        for (i in 1:3){
          leafletProxy("map",data=targetplan[[i]]) %>%
            addMarkers(clusterOptions = markerClusterOptions(),
                       lng=targetplan[[i]]$LON,lat=targetplan[[i]]$LAT,
                       icon=list(iconUrl=paste('icon/',choice[index[i]],'.png',sep = ""),iconSize=c(20,20)),
                       popup=paste("Name:",targetplan[[i]]$NAME,"<br/>",
                                   "Tel:",targetplan[[i]]$TEL,"<br/>",
                                   "Website:",a(targetplan[[i]]$URL, href = targetplan[[i]]$URL),"<br/>", # warning appears
                                   "Address:",targetplan[[i]]$ADDRESS),
                       group=choice[index[i]],layerId = i )
        }
        
        observeEvent(input$Subway,{
          p<-input$Subway
          proxy<-leafletProxy("map")
          
          if(p==TRUE){
            proxy %>% 
              addMarkers(data=sub.station, ~lng, ~lat,label = ~info,icon=icons(
                iconUrl = "icon/icons8-Bus-48.png",
                iconWidth = 10, iconHeight = 10),group="subway")
          }
          else proxy%>%clearGroup(group="subway")
          
        })
        
        ###############bus###############
        observeEvent(input$Bus,{
          p<-input$Bus
          proxy<-leafletProxy("map")
          
          if(p==TRUE){
            proxy %>% 
              addMarkers(data=bus.stop, ~lng, ~lat,label = ~info,icon=icons(
                iconUrl = "icon/bus.png",
                iconWidth =10, iconHeight = 10),layerId=as.character(bus.stop$info))
          }
          else proxy%>%removeMarker(layerId=as.character(bus.stop$info))
          
        })
        
        
      })
      
    }) 
    
  }
