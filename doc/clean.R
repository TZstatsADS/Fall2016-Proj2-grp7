data <- read.csv("C:/Users/LIU/Desktop/ADS/P2/NYPD_7_Major_Felony_Incidents.csv")
data <- data[as.numeric(data$Occurrence.Year) > 2000,]
crime <- data.frame(location = data$Location.1,borough = data$Borough)
library(plyr)
crime <- ddply(crime,.(location,borough),nrow)
split_lat <- function(loc){
  loc <- as.character(loc);
  loc <- gsub("[(*)]","",loc);
  list <- strsplit(loc, ",")
  split <- unlist(list);
  lat <-  as.numeric(split[1]);
  return (lat)
}
split_lon <- function(loc){
  loc <- as.character(loc);
  loc <- gsub("[(*)]","",loc);
  list <- strsplit(loc, ",")
  split <- unlist(list);
  lon <-  as.numeric(split[2]);
  return (lon)
}
lon <- c()
for(i in 1:length(crime$location)){
  lon[i] <- split_lon(crime$location[i])
}
lat <- c()
for(i in 1:length(crime$location)){
  lat[i] <- split_lat(crime$location[i])
}
crime <- cbind(crime,lon,lat)
save(crime, file='C:/Users/LIU/Desktop/ADS/P2/MANHATTANCRIME.RData')
rm(crime,data)

data <- read.csv("C:/Users/LIU/Desktop/ADS/P2/NYCCAS_2009_CD_annavg.csv")
data <- data[as.numeric(data$indicator_id) == 365 | as.numeric(data$indicator_id) == 370 |
               as.numeric(data$indicator_id) == 375 | as.numeric(data$indicator_id) == 383 |
               as.numeric(data$indicator_id) == 386 | as.numeric(data$indicator_id) == 391,]
location <- c('Battery Park City','Tribeca','Greenwich Village','SoHo','Lower East Side','Chinatown', 
              'Chelsea','Clinton','Midtown Business District','Stuyvesant Town','Turtle Bay',
              'Upper West Side','Upper East Side','Manhattanville', 'Hamilton Heights',
              'Central Harlem','East Harlem','Washington Heights','Inwood','Melrose','Mott Haven','Port Morris',
              'Hunts Point','Longwood', 'Morrisania','Crotona Park East','Highbridge','Concourse Village',
              'University Heights','Fordham, Mt Hope','East Tremont','Belmont','Bedford Park','Norwood, Fordham',
              'Riverdale','Kingsbridge','Marble Hill','Soundville','Parkchester','Throgs Nk.','Co-op City',
              'Pelham Bay','Pelham Parkway','Morris Park','Laconia','Wakefield','Williamsbridge',
              'Williamsburg','Greenpoint','Brooklyn Heights','Fort Greene','Bedford Stuyvesant','Bushwick',
              'East New York','Starrett City','Park Slope','Carroll Gardens','Sunset Park','Windsor Terrace',
              'Crown Heights North','Crown Heights South','Wingate','Bay Ridge','Dyker Heights','Bensonhurst',
              'Bath Beach','Borough Park','Ocean Parkway','Coney Island','Brighton Beach','Flatbush','Midwood',
              'Sheepshead Bay','Gerritsen Beach','Brownsville','Ocean Hill','East Flatbush','Rugby, Farragut',
              'Canarsie','Flatlands','Astoria','Long Island City','Sunnyside','Woodside','Jackson Heights',
              'North Corona','Elmhurst','South Corona','Ridgewood','Glendale','Maspeth','Forest Hills','Rego Park',
              'Flushing Bay Terrace','Fresh Meadows','Briarwood','Woodhaven','Richmond Hill',
              'Ozone Park','Howard Beach','Bayside','Douglastown','Little neck','Jamaica','St. Albans','Hollis',
              'Queens Village','Rosedale','The Rockaways','Broad Channel','Stapleton','Port Richmond',
              'New Springville','South Beach','Tottenville','Woodrow','Great Kills')
id <- c(101,101,102,102,103,103,104,104,105,106,106,107,108,109,109,110,111,112,112,
        201,201,201,202,202,203,203,204,204,205,205,206,206,207,207,208,208,208,209,209,210,210,210,211,211,211,212,212,
        301,301,302,302,303,304,305,305,306,306,307,307,308,309,309,310,310,311,311,312,312,313,313,314,314,315,315,316,316,317,317,318,318,
        401,401,402,402,403,403,404,404,405,405,405,406,406,407,408,408,409,409,410,410,411,411,411,412,412,412,413,413,414,414,
        501,501,502,502,503,503,503)
pol <- c('PM2.5','EC','NO2','SO2','O3')
polid <- c(365,370,375,383,386)
air <- join(data.frame(location = location,id = id),data.frame(id = data$geo_entity_id,value = data$data_value,
                                                               type = data$indicator_id),by = 'id',type = 'right')
air <- join(air,data.frame(pol = pol,type = polid),by = 'type',type = 'right')
air <- subset(air,select = c(location,value,pol))
save(air, file='C:/Users/LIU/Desktop/ADS/P2/MANHATTANPMAIR.RData')


