Meander= function(start_lon,start_lat,end_lon,end_lat,running_distance_in_mile,Nodes,Scores)
{
  library(stats)
  library(pryr)
  library(leaflet)
  library(maps)
  library(osrm)
  library(geosphere)
# Need Nodes: 1. Longi; 2. Lati;
  node_info=matrix(0,nrow=length(Scores)+2,ncol=3)

  node_info[1:length(Scores),]=c(Nodes[,1],Nodes[,2],Scores)
  num=dim(node_info)[1]
  node_info[num-1,]=c(start_lon,start_lat,0)
  node_info[num,]=c(end_lon,end_lat,0)
  start_node=num-1;
  end_node=num;
############## Prep ###################    
  distance=distm(node_info[,1:2])*1.25
  close_neib=t(apply(distance,2,order))
  sorted_dist=t(apply(distance,2,sort))
  nodes_passed=array(FALSE,dim=num)
  bestroute=array(0,dim=num+1)
  bestscore=-9999
  finaldist=0
################# Search ##################  
  route=array(0,dim=num)
  g=environment()
  findroute=function(x,d,tt) # x: current position; d: distance remains; tt: how many nodes visited, does not include x
  {
    if(x!=end_node) g$nodes_passed[x]=TRUE
    g$route[tt+1]=x
    if (x==end_node)
    {
      g$score=sum(node_info[route,3])
      if(g$score>g$bestscore)
      {
        g$bestscore=g$score
        #print(g$bestscore)
        g$bestroute=g$route
        g$bestroute[num+1]=tt+1
        g$finaldist=running_distance_in_mile*1609-d
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
  findroute(start_node,running_distance_in_mile*1609,0)
  b=Sys.time()
  b-a
  stops=bestroute[length(bestroute)]
  bestroute=bestroute[1:stops]  

  route_in_osm=matrix(node_info[start_node,1:2],ncol=2)
  for (i in 2:stops)
  {
    Akke=osrmRoute(c(1,node_info[bestroute[i-1],1],node_info[bestroute[i-1],2]),c(2,node_info[bestroute[i],1],node_info[bestroute[i],2]))
    print(Akke)
    route_in_osm=rbind(route_in_osm,as.matrix(Akke),node_info[bestroute[i],1:2])
    }
  return(list(bestroute,route_in_osm))
}

cai=Meander(-73.97396,40.78870,-73.96862,40.78819,5,randomnode[,1:2],randomnode[,3])

x=mean(randomnode[start_node,1],randomnode[end_node,1])
y=mean(randomnode[start_node,2],randomnode[end_node,2])
m <- leaflet() %>% setView(lng = x, lat =y, zoom =13)
m= m %>%addTiles() 
m= m %>% addCircles(lng=randomnode[,1],lat=randomnode[,2],radius=100,col="red")
m %>% addPolylines (lng=cai[,1],lat=cai[,2])
