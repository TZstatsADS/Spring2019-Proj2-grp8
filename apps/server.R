library(geosphere)
library(ggmap)
library(maptools)
library(leaflet)
library(leaflet.extras)
library(readr)
library(shinyalert)
library(rjson)
restaurant<-data.frame(na.omit(read_csv("../output/restaurant_final.csv")))
type <- unique(as.character(restaurant$CUISINE))
namedata<-c("Restaurant","Museum","Theatre","Gallery","Library")
Gallery<-na.omit(read.csv("../output/Gallery.csv",header=T))
Library<-na.omit(read.csv("../output/Library.csv",header=T))
Museum<-na.omit(read.csv("../output/Museum.csv",header=T))
Theatre<-na.omit(read.csv("../output/Theater.csv",header=T))
all_data<-list(Gallery=Gallery,Library=Library,Museum=Museum,Restaurant=restaurant,Theatre=Theatre)
register_google("AIzaSyA8OuCvy04PC3N-K9y6DdEc32hUpNyUrl8")
load("../output/subway_new.RData")
load("../output/bus.stop.RData")
source("../lib/global.R")
# Define a server for the Shiny app
#all_data1 = list(museum = museum,theatre = theatre, restaurant = restaurant)
#namedata1 = c('museum','theatre','restaurant')
Group <- c("Chinese","American","European","QuickMeal","Latin","Other","Asian",    
           "Pizza","Coffee","Drink&Sweets")
function(input, output) {
  
  
  #################Clear Choices############
  #################Clear Choices############
  observeEvent(input$button2,{
    proxy<-leafletProxy("map1")
    proxy %>%
      setView(lng = -73.971035, lat = 40.775659, zoom = 12) 
    
  })
  
  
  
  
  
  output$map1 <- renderLeaflet({
    
    map <- leaflet() %>% setView(-73.983,40.7639,zoom = 13)  %>% addProviderTiles(providers$Esri.WorldTopoMap)
      
    
    for (i in 1:5){
      leafletProxy('map1',data=all_data[[namedata[i]]]) %>%
        addMarkers(
          
          clusterOptions = markerClusterOptions(),
          lng=all_data[[namedata[i]]]$LON,
          lat=all_data[[namedata[i]]]$LAT,
          icon=list(iconUrl=paste('icon/',namedata[i],'.png',sep = ""),iconSize=c(20,20)),
          popup=paste("Name:",all_data[[namedata[i]]]$NAME,"<br/>",
                      "Tel:",all_data[[namedata[i]]]$TEL,"<br/>",
                      "Zipcode:",all_data[[namedata[i]]]$ZIP,"<br/>",
                      "Address:",all_data[[namedata[i]]]$ADDRESS),
          group=namedata[i])

    }
    map%>%hideGroup(c("Restaurant","Museum","Theatre","Gallery","Library")) 
    
    Type<-as.character(unique(restaurant$CUISINE))
 
    for (i in 1:length(Group)){
      leafletProxy("map1") %>%
        addMarkers(
          data=restaurant[restaurant$CUISINE==Type[i],],
          clusterOptions = markerClusterOptions(),
          lng=restaurant[restaurant$CUISINE==Type[i],]$LON,lat=restaurant[restaurant$CUISINE==Type[i],]$LAT,
          icon=list(iconUrl=paste('icon/','Restaurant','.png',sep = ""),iconSize=c(20,20)),
          popup=paste("Name:",restaurant$NAME,"<br/>",
                      "Tel:",restaurant$TEL,"<br/>",
                      "Rating:",restaurant$RATING,"<br/>",
                      "Price:",restaurant$PRICE,"<br/>",
                      "Cuisine:",restaurant$CUISINE,"<br/>",
                      "Tag:",restaurant$TAG,"<br/>",
                      "Address:",restaurant$ADDRESS,"<br/>",
                      "Grade:",restaurant$GRADE,"<br/>"
                      ),
          group=Group[i] )

    }
    map%>%hideGroup(Group)
    
  })
  
  observeEvent(input$region1,{
    leafletProxy("map1") %>%hideGroup(c(namedata,Group))%>%
      showGroup(input$region1)
    
    
  })    
  
  
  observeEvent(input$region2,{
    if(input$region2 == "NA" ){leafletProxy("map1")%>%showGroup(input$region1)}
    else {leafletProxy("map1")%>%
        hideGroup(c(namedata,Group))%>%
        showGroup(c(input$region2,input$region1))}
  })
  
  
  
  observeEvent(input$region3,{
    if("NA" == input$region3){leafletProxy("map1")%>%showGroup(c(input$region1,input$region2))}
    else {leafletProxy("map1")%>%
        hideGroup(c(namedata,Group))%>%
        showGroup(c(input$region3,input$region2,input$region1))}
  })
  
  observeEvent(input$type1,{
    if(input$type1 == 'ALL'){leafletProxy("map1")%>%showGroup(c(input$region1,input$region2,input$region2))}
    else {leafletProxy("map1")%>%
        hideGroup(c(namedata))%>%
        showGroup(c(input$type1))}
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
  
  # get the gallery data in the bounds
  GalleryInBounds <- reactive({
    if (is.null(input$map1_bounds))
      return(Gallery[FALSE,])
    bounds <- input$map1_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    return(
      subset(Gallery,
             LAT>= latRng[1] & LAT <= latRng[2] &
               LON >= lngRng[1] & LON <= lngRng[2])
    )
  })
  # get the library data in the bounds
  LibraryInBounds <- reactive({
    if (is.null(input$map1_bounds))
      return(Library[FALSE,])
    bounds <- input$map1_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    return(
      subset(Library,
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
    library_subset=LibraryInBounds()
    gallery_subset=GalleryInBounds()
    
    if (nrow(museum_subset) != 0){
      Museum = museum_subset
    }
    
    if (nrow(theatre_subset) != 0){
      Theatre = theatre_subset
    }
    
    if (nrow(restaurant_subset) != 0){
      restaurant = restaurant_subset
    }
    
    if (nrow(library_subset) != 0){
      Library = library_subset
    }
    
    if (nrow(gallery_subset) != 0){
      Gallery = gallery_subset
    }
    
    output$table1 <- renderDataTable({
      
      if (input$region1 == 'Museum'){
        print(Museum[,c(1,2,4)])
        
      }
      else if(input$region1 == 'Theatre'){
        print(Theatre[,c(1,2,4)])
        
      }
      else if(input$region1 == 'Gallery'){
        print(Gallery[,c(1,2,4)])
      }
      else if(input$region1 == 'Library'){
        print(Library[,c(1,6)])
      }
      else if(input$region1 == 'Restaurant') {
        if (input$type1 == 'ALL'){
          print(restaurant[,c(1,5,12,6)])
        }
        else{
          print(restaurant[restaurant$CUISINE == as.character(input$type1),c(1,5,12,6)])
        }
        
      }
    },
    options = list(
      scrollX=T,
      pageLength = 3,
      lengthMenu = c(3, 5, 8))) 
    output$table2 <- renderDataTable({
      
      if (input$region2 == 'Museum'){
        print(Museum[,c(1,2,4)])
        
      }
      else if(input$region2 == 'Theatre'){
        print(Theatre[,c(1,2,4)])
        
      }
      else if(input$region2 == 'Gallery'){
        print(Gallery[,c(1,2,4)])
      }
      else if(input$region2 == 'Library'){
        print(Library[,c(1,6)])
      }
      else if(input$region2 == 'Restaurant') {
        if (input$type1 == 'ALL'){
          print(restaurant[,c(1,5,12,6)])
        }
        else{
          print(restaurant[restaurant$CUISINE == as.character(input$type1),c(1,5,12,6)])
        }    
      }
    },
      options = list(
        scrollX=T,
        pageLength = 3,
        lengthMenu = c(3, 5, 8)))
    output$table3 <- renderDataTable({
      
      if (input$region3 == 'Museum'){
        print(Museum[,c(1,2,4)])
        
      }
      else if(input$region3 == 'Theatre'){
        print(Theatre[,c(1,2,4)])
        
      }
      else if(input$region3 == 'Gallery'){
        print(Gallery[,c(1,2,4)])
      }
      else if(input$region3 == 'Library'){
        print(Library[,c(1,6)])
      }
      else if(input$region3 == 'Restaurant') {
        if (input$type1 == 'ALL'){
          print(restaurant[,c(1,5,12,6)])
        }
        else{
          print(restaurant[restaurant$CUISINE == as.character(input$type1),c(1,5,12,6)])
        }
      }
    },options = list(
      scrollX=T,
      pageLength = 3,
      lengthMenu = c(3, 5, 8))
    )
    }
      )
 
    
    observeEvent(input$submit,{
      if(input$location=="Current Location"){
        coord<-getlatlng()
        lat<-coord[1]
        long<-coord[2]
        output$map<-renderLeaflet({
          
          map <- leaflet()%>%setView()%>% addProviderTiles(providers$Esri.WorldTopoMap)
          
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
          shinyalert("Please enter a valid Address!",type="error")
        }else{
          output$map<-renderLeaflet(
            {    map<-leaflet() %>% addProviderTiles(providers$Esri.WorldTopoMap)%>%
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
                'Feeling Lucky' again for another recommendation!", sep="")
        })
        
        
        leafletProxy("map")%>%
          clearMarkerClusters()
        
        for (i in 1:3){
          leafletProxy("map",data=targetplan[[i]]) %>%
            addMarkers(clusterOptions = markerClusterOptions(),
                       lng=targetplan[[i]]$LON,lat=targetplan[[i]]$LAT,
                       icon=list(iconUrl=paste('icon/',choice[index[i]],'.png',sep = ""),iconSize=c(20,20)),
                       popup=paste("Name:",a(targetplan[[i]]$NAME,href = targetplan[[i]]$URL),"<br/>",
                                   "Tel:",targetplan[[i]]$TEL,"<br/>",
                                   "Address:",targetplan[[i]]$ADDRESS),
                       group=choice[index[i]],layerId = i )
        }
        
        observeEvent(input$Subway,{
          p<-input$Subway
          proxy<-leafletProxy("map")
          
          if(p==TRUE){
            proxy %>% 
              addMarkers(data=subway, ~lng, ~lat,label = ~info,icon=icons(
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
