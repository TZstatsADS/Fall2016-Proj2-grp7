load('C:/Users/LIU/Desktop/ADS/P2/MANHATTANCRIME.RData')

data <- read.csv('C:/Users/LIU/Desktop/ADS/P2/59_110.csv')

data$Safety <- c(0)
for(i in 1:length(data$Safety)){for(j in 1:length(crime$borough)){
    if((as.numeric(data$Latitude[i])-as.numeric(crime$lat[j]))^2+(as.numeric(data$Longitude[i])-as.numeric(crime$lon[j]))^2 < 3e-6){
      data$Safety[i] <- data$Safety[i] + as.numeric(crime$V1[j])
    }
}}

for(i in 1:length(data$Latitude)){
  if(as.numeric(data$Safety[i]) > 1000)data$Safety[i] <- 1
  else if(as.numeric(data$Safety[i]) > 500)data$Safety[i] <- 2
  else if(as.numeric(data$Safety[i]) > 200)data$Safety[i] <- 3
  else if(as.numeric(data$Safety[i]) > 50)data$Safety[i] <- 4
  else data$Safety[i] <- 5
}

write.csv(data,'C:/Users/LIU/Desktop/ADS/P2/59_110.csv')