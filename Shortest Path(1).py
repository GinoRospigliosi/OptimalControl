#!/usr/bin/env python
# coding: utf-8

# In[42]:


import random
import pandas as pd 
from datetime import datetime
random.seed(datetime.now())
df = pd.read_csv('tracks.csv',nrows = 35)


        
class Station:
    
    def __init__(self, name):
        self.name = name
        self.adj_stations = []
        self.shortest_distance = 9999999
        self.previous_station = None
        self.previous_line = ""
        self.seen = False
        self.line_list = []
        self.station_delay = random.randint(5, 15)
        print(self.station_delay)
        
    def add_edge(self,station,weight,line_color):
        self.adj_stations.append([station,weight,line_color])
        if not(line_color in self.line_list):
            self.line_list.append(line_color)
        
        
    def set_seen(self,seen):
        self.seen = seen
        
    def set_previous_line(self,line):
        self.previous_line = line
        
class Graph:
    def __init__(self):
        self.line = {
            "Green":random.randint(0, 20),
            "Red":random.randint(0, 20),
            "Silver":random.randint(0, 20),
            "Orange":random.randint(0, 20),
            "Blue":random.randint(0, 20),
            "Yellow":random.randint(0, 20)
            
        }
        self.current_line = ""
        self.stations = []
        
    def add_stations(self,lst):
        
        for station in lst:
            self.stations.append(station)
    
    def ret_station(self,name):
        for i in range(0,len(self.stations)):
            if name == self.stations[i].name:
                return self.stations[i]
            
    def set_current_line(self,line):
        self.curent_line = line
        
        
        
        
college_park = Station("College Park")
fort_toten = Station("Fort Totten")
gallery_place = Station("Gallery Place")
lenfant_plaza = Station("L'Enfant Plaza")
metro_center = Station("Metro Center")
rosslyn = Station("Rosslyn")
east_falls_church = Station("East Falls Church")
tysons_corner = Station("Tysons Corner")

graph = Graph()



g = [college_park,
fort_toten,
gallery_place,
lenfant_plaza,
metro_center,
rosslyn,
east_falls_church,
tysons_corner]

graph.add_stations(g)

for index, row in df.iterrows():
    from_station = row['From']
    to_station = row['To']
    time = row['Time (Minutes)']
    color = row['Line']
    station = graph.ret_station(from_station)
    station.add_edge(graph.ret_station(to_station),time,color)


# In[43]:



def dijsktra(graph, source_name, destination_name):
    move_list = []
    
    source = graph.ret_station(source_name)
    source.shortest_distance = 0
    opt_line = ""
    min_price = 999999
    
    #graph.set_current_line(min(graph.line['Green'],graph.line['Yellow']))
    #source.set_previous_line(min(graph.line['Green'],graph.line['Yellow']))
    
    for color in source.line_list:
if graph.line[color] < min_price:
    min_price = graph.line[color]
    graph.set_current_line(color)
    source.set_previous_line(color)

    working_stations = []
    working_stations.append(source)
    
    while working_stations != []:
current_station = working_stations[0]
current_station.set_seen = True
for [station,weight,line_color] in current_station.adj_stations:
    if not station.seen:
        if line_color != graph.current_line:
            trans_weight = (station.station_delay) + (graph.line[line_color])
        else:
            trans_weight = 0
            
        old_cost = station.shortest_distance
        new_cost = current_station.shortest_distance + weight + trans_weight
       
        if new_cost < old_cost:
            graph.set_current_line(line_color)
            working_stations.append(station)
            station.shortest_distance = new_cost
            station.previous_station = current_station
            station.set_previous_line(line_color)
            
working_stations = working_stations[1:]
    
    destination = graph.ret_station(destination_name)
    
    curr = destination
    while True:
if curr == None:
    break
else:
    move_list.append([curr.name,curr.previous_line,curr.shortest_distance])
    curr = curr.previous_station
    return move_list[::-1]
    


# In[44]:


print(graph.line)
print(graph.ret_station("College Park").line_list)


# In[51]:


for line in graph.line:
    print("Line: " + line
          + ", Line Delay: " + str(graph.line[line]))


# In[52]:


for station in graph.stations:
    print("Staion: " + station.name
          + ", Station Delay: " + str(station.station_delay))


# In[53]:


for moves in dijsktra(graph,"College Park","Tysons Corner"):
    print("Starting Station: " + moves[0]
          + ", Line Taken: " + moves[1] + ", Cost: " + str(moves[2]))


# In[ ]:





# In[ ]:




