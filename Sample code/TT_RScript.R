setwd("D:/SA study/R travel Time")
library(readxl)
#import excel coordinate file
LatLon_forR <- read_excel("D:/SA study/R travel Time/LatLon_forR.xlsx")
View(LatLon_forR)
#create new coordinate var by concatenating lat and long
LatLon_forR$coord=paste(LatLon_forR$LatDD,LatLon_forR$LongDD, sep="+")
#Install R google api package 
install.packages("gmapsdistance")
library(gmapsdistance)
set.api.key("AIzaSyBOHv2ETFy8VMjOVqXxqJ5B2wDhz9ZjzKQ")

options(max.print=1000000)
install.packages("plyr")
library(plyr)

#estimate travel time
y=c(LatLon_forR$coord)
##No highway, pessimistic 
r_noH=gmapsdistance(origin = y, 
                    destination = "-29.838457+30.997391", 
                     mode = "driving", traffic_model = "pessimistic", avoid= "highways", dep_date="2017-10-11", dep_time="10:00:00")

TT=r_noH$Time
Dis=r_noH$Distance

TT$Time_min_NoHP=TT$'Time.-29.838457+30.997391'/60
Dis$Dist_km_NoHP=Dis$`Distance.-29.838457+30.997391`/1000

TT2=subset(rename(TT, c("or"="coord")),select=c('coord','Time_min_NoHP'))
Dis2=subset(rename(Dis, c("or"="coord")), select=c('coord', 'Dist_km_NoHP'))

Lat=LatLon_forR

TT3=merge(x=Lat,y=TT2, by="coord", all.x=TRUE)
NoH_P=subset(merge(x=TT3,y=Dis2,by="coord", all.x=TRUE), select=c('Patient_ID','Time_min_NoHP', 'Dist_km_NoHP'))

XX=merge(x=TT3,y=Dis2,by="coord", all.x=TRUE)

write.csv(XX, "D:/SA study/R travel Time/ZZ.csv")


##highway, pessimistic
r_HP=gmapsdistance(origin = y, 
                   destination = "-29.838457+30.997391", 
                   mode = "driving", traffic_model = "pessimistic", dep_date="2017-10-11", dep_time="10:00:00")

TT=r_HP$Time
Dis=r_HP$Distance

TT$Time_min_HP=TT$'Time.-29.838457+30.997391'/60
Dis$Dist_km_HP=Dis$`Distance.-29.838457+30.997391`/1000

TT2=subset(rename(TT, c("or"="coord")),select=c('coord','Time_min_HP'))
Dis2=subset(rename(Dis, c("or"="coord")), select=c('coord', 'Dist_km_HP'))

Lat=LatLon_forR

TT3=merge(x=Lat,y=TT2, by="coord", all.x=TRUE)
H_P=subset(merge(x=TT3,y=Dis2,by="coord", all.x=TRUE), select=c('Patient_ID','Time_min_HP', 'Dist_km_HP'))

print(H_P)

##No Highway, Optimistic
r_noH_O=gmapsdistance(origin = y, 
                    destination = "-29.838457+30.997391", 
                    mode = "driving", traffic_model = "optimistic", avoid= "highways", dep_date="2017-10-11", dep_time="10:00:00")

TT=r_noH_O$Time
Dis=r_noH_O$Distance

TT$Time_min_NoHO=TT$'Time.-29.838457+30.997391'/60
Dis$Dist_km_NoHO=Dis$`Distance.-29.838457+30.997391`/1000

TT2=subset(rename(TT, c("or"="coord")),select=c('coord','Time_min_NoHO'))
Dis2=subset(rename(Dis, c("or"="coord")), select=c('coord', 'Dist_km_NoHO'))

Lat=LatLon_forR

TT3=merge(x=Lat,y=TT2, by="coord", all.x=TRUE)
NoH_O=subset(merge(x=TT3,y=Dis2,by="coord", all.x=TRUE), select=c('Patient_ID','Time_min_NoHO', 'Dist_km_NoHO'))

##Highway, Optimistic
r_HO=gmapsdistance(origin = y, 
                   destination = "-29.838457+30.997391", 
                   mode = "driving", traffic_model = "optimistic", dep_date="2017-10-11", dep_time="10:00:00")

TT=r_HO$Time
Dis=r_HO$Distance

TT$Time_min_HO=TT$'Time.-29.838457+30.997391'/60
Dis$Dist_km_HO=Dis$`Distance.-29.838457+30.997391`/1000

TT2=subset(rename(TT, c("or"="coord")),select=c('coord','Time_min_HO'))
Dis2=subset(rename(Dis, c("or"="coord")), select=c('coord', 'Dist_km_HO'))

Lat=LatLon_forR

TT3=merge(x=Lat,y=TT2, by="coord", all.x=TRUE)
H_O=subset(merge(x=TT3,y=Dis2,by="coord", all.x=TRUE), select=c('Patient_ID','Time_min_HO', 'Dist_km_HO'))


#combine all time and distance dataset

GA1=merge(x=NoH_P, y=NoH_O, by='Patient_ID', All.x=TRUE)
GA2=merge(x=GA1, y=H_P, by='Patient_ID', All.x=TRUE)
GA3=merge(x=GA2, y=H_O, by= 'Patient_ID', All.x=TRUE)


print(GA3)


write.csv(GA3, "D:/SA study/R travel Time/GeoAccess.csv")


