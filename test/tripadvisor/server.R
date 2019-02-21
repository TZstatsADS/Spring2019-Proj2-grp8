
library(shiny)
library(leaflet)
library(leaflet.extras)
library(rebird)
library(geosphere)
library(ggmap)
source("../global.R")
namedata<-c("Deli","Museum","Theater","Gallery","Library","Market")
Deli<-na.omit(read.csv("../data/Deli.csv",header=T))
Deli$URL<-"Unavailable"
Market<-na.omit(read.csv("../data/Market.csv",header=T))
Market$URL<-"Unavailable"
Gallery<-na.omit(read.csv("../data/Gallery.csv",header=T))
Library<-na.omit(read.csv("../data/Library.csv",header=T))
Museum<-na.omit(read.csv("../data/Museum.csv",header=T))
Restaurant<-na.omit(read.csv("../data/Restaurant.csv",header=T))
Restaurant$URL<-"Unavailable"
Theater<-na.omit(read.csv("../data/Theater.csv",header=T))
all_data<-list(Deli=Deli,Market=Market,Gallery=Gallery,Library=Library,Museum=Museum,Restaurant=Restaurant,Theater=Theater)
register_google("AIzaSyA8OuCvy04PC3N-K9y6DdEc32hUpNyUrl8")
load("../output/sub.station.RData")
load("../output/bus.stop.RData")
shinyServer(function(input, output) {


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

  #roll the dice for random choice

  
  output$locationin<-renderText(input$location)
  observeEvent(input$submit4,{
    index<-sample(1:4,2,replace=F)
    choice<-c("Theater","Museum","Gallery","Library","Restaurant")
    choice1<-choice[index[1]]
    choice2<-choice[index[2]]
    index[3]<-length(choice)
    choice3<-choice[index[3]]
    output$c1<- renderText({choice1})
    output$c2<- renderText({choice2})
    
    data_candidate<-all_data[c(choice1,choice2,choice3)]
   
    ##Get candidates according to the radius:
    data_select<-lapply(data_candidate,get_candidate,Lon0=long,Lat0=lat,r=input$distance*1000)
    
    targetplan<-lapply(data_select,randomchoice)
    output$target1<-renderText(as.character(targetplan[[1]][1,"NAME"]))
    output$target2<-renderText(as.character(targetplan[[2]][1,"NAME"]))
    output$target3<-renderText(as.character(targetplan[[3]][1,"NAME"]))
    
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
            iconUrl = "../output/icons8-Bus-48.png",
            iconWidth = 7, iconHeight = 7),group="subway")
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
            iconUrl = "../output/icons8-Bus-48.png",
            iconWidth = 7, iconHeight = 7),layerId=as.character(bus.stop$info))
      }
      else proxy%>%removeMarker(layerId=as.character(bus.stop$info))
      
    })

    
    })
  
  }) 
})
