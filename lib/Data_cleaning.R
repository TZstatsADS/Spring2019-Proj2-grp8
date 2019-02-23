library(tidyverse)
#museum data
museum<-read.csv("../data/MUSEUM.csv",as.is=T)
museum$the_geom<-substr(museum$the_geom,start=8,stop=nchar(museum$the_geom)-1)
n<-nrow(museum)
ll<-museum$the_geom
LAT<-c()
LON<-c()
for(i in 1:n){
  st<-strsplit(ll[i],split=" ")
  LAT<-c(LAT,as.numeric(st[[1]][2]))
  LON<-c(LON,as.numeric(st[[1]][1]))
}
museum$LAT<-LAT
museum$LON<-LON
museum<-museum%>%
  select(NAME,TEL,URL,ADDRESS=ADRESS1,LAT,LON)
write_csv(museum, "../output/Museum.csv")
#theater data
theater<-read.csv("../data/DOITT_THEATER_01_13SEPT2010.csv",as.is=T)
theater$the_geom<-substr(theater$the_geom,start=8,stop=nchar(theater$the_geom)-1)
n<-nrow(theater)
ll<-theater$the_geom
LAT<-c()
LON<-c()
for(i in 1:n){
  st<-strsplit(ll[i],split=" ")
  LAT<-c(LAT,as.numeric(st[[1]][2]))
  LON<-c(LON,as.numeric(st[[1]][1]))
}
theater$LAT<-LAT
theater$LON<-LON
theater<-theater%>%
  select(NAME,TEL,URL,ADDRESS=ADDRESS1,ZIP,LON,LAT)
write_csv(theater, "../output/Theater.csv")
#library data
library<-read.csv("../data/LIBRARY.csv",as.is=T)
library$the_geom<-substr(library$the_geom,start=8,stop=nchar(library$the_geom)-1)
n<-nrow(library)
ll<-library$the_geom
LAT<-c()
LON<-c()
for(i in 1:n){
  st<-strsplit(ll[i],split=" ")
  LAT<-c(LAT,as.numeric(st[[1]][2]))
  LON<-c(LON,as.numeric(st[[1]][1]))
}
library$LAT<-LAT
library$LON<-LON
library$ADDRESS<-paste(library$HOUSENUM,library$STREETNAME)
library<-library%>%
  select(NAME,ZIP,URL,LON,LAT,ADDRESS)
write_csv(library, "../output/Library.csv")
#gallery data
gallery<-read.csv("../data/ART_GALLERY.csv",as.is=T)
gallery$the_geom<-substr(gallery$the_geom,start=8,stop=nchar(gallery$the_geom)-1)
n<-nrow(gallery)
ll<-gallery$the_geom
LAT<-c()
LON<-c()
for(i in 1:n){
  st<-strsplit(ll[i],split=" ")
  LAT<-c(LAT,as.numeric(st[[1]][2]))
  LON<-c(LON,as.numeric(st[[1]][1]))
}
gallery$LAT<-LAT
gallery$LON<-LON
gallery<-gallery%>%
  select(NAME,TEL,URL,ADDRESS=ADDRESS1,ZIP,LAT,LON)
write_csv(gallery, "../output/Gallery.csv")

res<-read.csv("../output/restaurant_complete.csv")
res<-res[!is.na(res$LAT),]
res$TEL<-res$PHONE
res<-res[,c(-1,-2)]
write_csv(res, "../output/restaurant_final.csv")
