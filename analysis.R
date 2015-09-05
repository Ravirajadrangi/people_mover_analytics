library(dplyr)
library(XML)
#library(leaflet)
load("stops.rda")



base <- "http://bustracker.muni.org/InfoPoint/XML/vehiclelocation.xml"
xml_obj <- xmlParse(base)
locations <- xmlToDataFrame(xml_obj) %>% filter(runid != "<NA>")

#leaflet(data = vechiclelocations) %>%  11addTiles() %>% addMarkers(~longitude, ~latitude)
#peoplemover <- gs_title("Gapminder")

base <- "http://bustracker.muni.org/InfoPoint/XML/stopdepartures.xml"
xml_obj <- xmlParse(base)
stop_departures <- xmlToList(xml_obj) 

delays <- data.frame(stopID = unlist(lapply(stop_departures[-1], function(x) x[[1]])),
              dev = as.numeric(unlist(lapply(stop_departures[-1], function(x) x[[3]][[3]]))) /60 ,
              edt = unlist(lapply(stop_departures[-1], function(x) x[[3]][[1]])),
              sdt = unlist(lapply(stop_departures[-1], function(x) x[[3]][[2]])),
              
)

delays %>% filter(dev != 0)
