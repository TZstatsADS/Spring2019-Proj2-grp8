packages.used=c("leaflet","geosphere","ggmap","RJSONIO","shiny","corrgram","plyr","ggplot2","shinydashboard","shinythemes","XML")

# check packages that need to be installed.
packages.needed=setdiff(packages.used, 
                        intersect(installed.packages()[,1], 
                                  packages.used))
# install additional packages
if(length(packages.needed)>0){
  install.packages(packages.needed, dependencies = TRUE)
}


library(leaflet)
library(geosphere)
library(ggmap)
require(RJSONIO)
library(shiny)
library(corrgram)
library(plyr)
library(ggplot2)
library(shinydashboard)
library(shinythemes)
library(XML)

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

Type<-as.character(unique(Restaurant$TYPE))
Selection=list(N.A="N.A",Market="Market",Deli="Deli",Library="Library",Theater="Theater",Museum="Museum",Gallery="Gallery",Restaurant=Type)


randomchoice<-function(data){
  n<-nrow(data)
  index<-sample(1:n,1)
  return(data[index,])
}


geocodeAdddress <- function(address) {
  url <- "http://maps.google.com/maps/api/geocode/json?address="
  url <- URLencode(paste(url, address, "&sensor=false", sep = ""))
  x <- fromJSON(url, simplify = FALSE)
  if (x$status == "OK") {
    out <- c(x$results[[1]]$geometry$location$lng,x$results[[1]]$geometry$location$lat)
  } else {
    out <- NA
  }
  Sys.sleep(0.2)  # API only allows 5 requests per second
  out
}


##Get Index for candidates
get_Ind<-function(data,Lon0,Lat0,r){
  coords<-cbind(data$LON,data$LAT)
  dis<-distm(coords,c(Lon0,Lat0), fun = distHaversine)
  Ind<-dis<r
  return(list(dis=dis,Ind=Ind))
}

##Get data:
get_candidate<-function(data,Lon0,Lat0,r){
  coords<-cbind(data$LON,data$LAT)
  dis<-distm(coords,c(Lon0,Lat0), fun = distHaversine)
  Ind<-dis<r
  return(data[Ind,])
}



##########Give centers based on the selection
########Output is dataframe. if no data satisfying the conditions, error messages will appear
get_center<-function(choice1,choice2,choice3,Lon0,Lat0,distance,radius){
  
  if (choice1 %in% Type){ choice1="Restaurant"}
  if (choice2 %in% Type){ choice2="Restaurant"}
  if (choice3 %in% Type){ choice3="Restaurant"}
  
  distance=distance*1000
  radius=radius*1000
  ##Check how many choices are made
  null2<-is.na(choice2)
  null3<-is.na(choice3)
  
  ##If the user only select "Choice1"
  if (null2 & null3){
    data_candidate<-all_data[[choice1]]
    ##Get candidates according to the radius:
    output_data<-get_candidate(data_candidate,Lon0=Lon0,Lat0=Lat0,r=distance)
    if ((dim(output_data)[1]==0)){
      mess<-"Sorry,No place found! Please try Longer Distance"
      return(mess)
    } else{
      return(output_data)
    }
  }
  
  ##If the user only select "Choice1" and "Choice 2"
  if (!null2 & null3){
    data_candidate<-all_data[c(choice1,choice2)]
    data_candidate<-na.omit(data_candidate)
    ##Get candidates according to the radius:
    data_select<-lapply(data_candidate,get_candidate,Lon0=Lon0,Lat0=Lat0,r=distance)
    D1<-na.omit(data_select[[choice1]])
    D2<-na.omit(data_select[[choice2]])
    
    if ((dim(D1)[1]==0)|((dim(D2)[1]==0))){
      mess<-"Sorry,No place found! Please try Longer Distance"
      return(mess)
    } else {
      coords1<-D1[,c("LON","LAT")]
      coords2<-D2[,c("LON","LAT")]
      ##Culculate distance between choices and selected the centers
      Dis2<-distm(coords1,coords2, fun = distHaversine)
      Inx2<-Dis2<radius
      output_data<-D1[!(colSums(Inx2)==0),]
      
      if(dim(output_data)[1]==0){
        mess<-"Sorry,No place found! Please try Longer Radius"
        return(mess)
      } else{
        return(output_data)
      }
    }
  }
  
  ##If the user selecte all choices
  if (!null2 & !null3){
    data_candidate<-all_data[c(choice1,choice2,choice3)]
    
    ##Get candidates according to the radius:
    data_select<-lapply(data_candidate,get_candidate,Lon0=Lon0,Lat0=Lat0,r=distance)
    D1<-na.omit(data_select[[choice1]])
    D2<-na.omit(data_select[[choice2]])
    D3<-na.omit(data_select[[choice3]])
    
    if ((dim(D1)[1]==0)|((dim(D2)[1]==0))|((dim(D3)[1]==0))){
      mess<-"Sorry,No place found! Please try Longer Distance"
      return(mess)
    } else {
      coords1<-D1[,c("LON","LAT")]
      coords2<-D2[,c("LON","LAT")]
      coords3<-D3[,c("LON","LAT")]
      
      ##Culculate distance between choices
      Dis2<-distm(coords1,coords2, fun = distHaversine)
      Dis3<-distm(coords1,coords3, fun = distHaversine)
      Inx2<-Dis2<radius
      Inx3<-Dis3<radius
      output_data<-D1[(!(colSums(Inx2)==0))&(!(colSums(Inx3)==0)),]
      
      if(dim(output_data)[1]==0){
        mess<-"Sorry,No place found! Please try Longer Radius"
        return(mess)
      } else{
        return(output_data)
      }
    }
  }
}

##Testing
# data<-get_center("Deli","Supermarket",NA,-73.68,40.67,0.1,0.01)
# choice1<-"Deli"
# choice2<-"Supermarket"
# choice3<-NA
# Lon0<--73.68
# Lat0<-40.67
# distance<-0.03
# radius<-0.01
# 
# name<-data$NAME[1]
