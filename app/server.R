library(geosphere)
library(ggmap)

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
all_data1 = list(museum = museum,theatre = theatre, restaurant = restaurant)
namedata1 = c('museum','theatre','restaurant')
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
    
    map <- leaflet() %>%addProviderTiles('Esri.WorldTopoMap') %>%
      setView(-73.983,40.7639,zoom = 13)
    
    for (i in 1:length(namedata1)){
      leafletProxy('map1',data=all_data[[namedata1[i]]]) %>%
        addMarkers(
          
          clusterOptions = markerClusterOptions(),
          lng=all_data1[[namedata1[i]]]$LON,
          lat=all_data1[[namedata1[i]]]$LAT,
          group=namedata1[i] )
      print(head(all_data1[[namedata1[i]]]$LON))
      print(head(all_data1[[namedata1[i]]]$LAT))
    }
    map%>%hideGroup(c('museum','theatre'))
    
     Type<-as.character(unique(restaurant$TYPE))
     Group<-c('American', 'Asian', 'Chinese' ,'Dessert', 'European', 'French','Italian', 'Mexcian' ,'Other', 'QuickMeal' , 'Seafood')
     for (i in 1:11){
       leafletProxy("map1") %>%
         addMarkers(
           data=Restaurant[Restaurant$TYPE==Type[i],],
           clusterOptions = markerClusterOptions(),
           lng=Restaurant[Restaurant$TYPE==Type[i],]$LON,lat=Restaurant[Restaurant$TYPE==Type[i],]$LAT,
           group=Group[i] )
     }
     map%>%hideGroup(c('American', 'Asian', 'Chinese' ,'Dessert', 'European', 'French','Italian', 'Mexcian' ,'Other', 'QuickMeal' , 'Seafood'))

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
  
  # observe({
  #   
  #   housing_sort=marksInBounds()
  #   
  #   if(nrow(housing_sort)!=0){
  #     
  #     action=apply(housing_sort,1,function(r){
  #       addr=r["addr"]
  #       lat=r["lat"]
  #       lng=r["lng"]
  #       paste0("<a class='go-map' href='' data-lat='",lat,"'data-lng='",lng,"'>",addr,'</a>')   
  #     }
  #     )
  #     
  #     housing_sort$addr=action
  #     output$rank <- renderDataTable(housing_sort[,c("addr","price","bedrooms","bathrooms")],escape=FALSE)
  #     
  #     
  #     
  #     
  #   }
  #   else{
  #     
  #     output$rank=renderDataTable(housing_sort[,c("addr","price","bedrooms","bathrooms")])
  #   }
  # })
  # 
  
  # Fill in the spot we created for a plot
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
        choice<-c("Theatre","Museum","Gallery","Library","Restaurant")
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
