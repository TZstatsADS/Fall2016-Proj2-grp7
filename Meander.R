library(stats)
library(pryr)
library(leaflet)
library(maps)
library(osrm)
###\\\\\\\\\\\INPUT//////////###
trials=200
start_node=1
end_node=round(runif(1,1,70))
running_distance_in_kilometer=9
############################ Generating Random Nodes ##########################

#a:_, b:<, c:^, d:> 
border=matrix(c(40.7,40.690,-74.043,-73.983,40.877,40.808,-73.930,-73.916),nrow=2)
b=matrix(0,nrow=2,ncol=2)
for(i in 1:2)
{
  b[1,i]=(border[i,3]-border[i,1])/(border[i,4]-border[i,2]) # slope
  b[2,i]=border[i,1]-border[i,2]*b[1,i]                      # intercept
}
randomnode=matrix(nrow=trials,ncol=3)
randomnode[,1]=runif(trials,-74.025,-73.906)
randomnode[,2]=runif(trials,40.701,40.877)
for(i in 1:trials)
{
  if((randomnode[i,1]*b[1,1]+b[2,1]) < randomnode[i,2]) randomnode[i,]=NA
  else if((randomnode[i,1]*b[1,2]+b[2,2]) > randomnode[i,2]) randomnode[i,]=NA
}
for (i in trials:1)
  if (is.na(randomnode[i,1])) randomnode=randomnode[-i,]
##################################### SCORING ########################################
num=dim(randomnode)[1]
randomnode[,3]=runif(num,0,100)
#################################### DATA PREP #####################################
library(geosphere)
distance=distm(randomnode[,1:2])*1.42
close_neib=t(apply(distance,2,order))
sorted_dist=t(apply(distance,2,sort))
nodes_passed=array(FALSE,dim=num)
bestroute=array(0,dim=num+1)
bestscore=-9999
finaldist=0
##################################### Search #####################################
route=array(0,dim=num)
g=globalenv()
findroute=function(x,d,tt) # x: current position; d: distance remains; tt: how many nodes visited, does not include x
{
  g$nodes_passed[x]=TRUE
  g$route[tt+1]=x
  if (x==end_node)
  {
    g$score=sum(randomnode[route,3])
    if(g$score>g$bestscore)
    {
      print(g$bestscore)
      g$bestscore=g$score
      print(g$bestscore)
      g$bestroute=g$route
      g$bestroute[num+1]=tt+1
      g$finaldist=running_distance_in_kilometer*1000-d
    }
  }
  else {
  for(i in 2:num)
  {
    j=close_neib[x,i]
    if((distance[x,j]+distance[j,end_node])>d) break
    else if(g$nodes_passed[j]==FALSE & j!=end_node)
    {
      findroute(j,d-distance[x,j],tt+1)
    }
  }
    if(distance[x,end_node]<=d) findroute(end_node,d-distance[x,end_node],tt+1)
  }
  g$nodes_passed[x]=FALSE
}

a=Sys.time()
findroute(1,running_distance_in_kilometer*1000,0)
b=Sys.time()
b-a
stops=bestroute[length(bestroute)]
bestroute=bestroute[1:stops]
  
############################# Output #############################
x=mean(randomnode[start_node,1],randomnode[end_node,1])
y=mean(randomnode[start_node,2],randomnode[end_node,2])
m <- leaflet() %>% setView(lng = x, lat =y, zoom =13)
m= m %>%addTiles() 
m= m %>% addCircles(lng=randomnode[,1],lat=randomnode[,2],radius=100,col="red")
#m= m%>% addPopups(lng=randomnode[,1],lat=randomnode[,2],as.character(round(randomnode[,3])),options = popupOptions(closeButton = FALSE,minWidth = 5,maxWidth = 12))
m %>% addPolylines (lng=randomnode[bestroute,1],lat=randomnode[bestroute,2]) %>% addPopups(lng=randomnode[end_node,1],lat=randomnode[end_node,2],as.character(round(finaldist*0.62137/1000,1)))

###################################################################
#cai=osrmRoute(c(1,randomnode[4,1],randomnode[4,2]),c(2,randomnode[end_node,1],randomnode[end_node,2]))

