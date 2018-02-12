library(readr)
library(tidyr)
library(dplyr)
library(lubridate)
library(ggplot2)
library(reshape2)
library(ggthemes)
library(rsconnect)



s <- read_csv("s.csv")
s$shooting_incidents_total[s$shooting_incidents_total=="-"] <- 0
s$robbery_total[s$robbery_total=="-"] <- 0
s$carnapping_total[s$carnapping_total=="-"] <- 0
s$others_total[s$others_total=="-"] <- 0
s$total_number_of_incidents[s$total_number_of_incidents=="-"] <- 0

totalByYear <- s %>%
  select(year,shooting_incidents_total,robbery_total,carnapping_total,
         others_total,total_number_of_incidents)%>%
  group_by(year)%>%
  summarise(
            other_Crimes = sum(as.numeric(others_total)),
            total_Carnapping = sum(as.numeric(carnapping_total)),
            total_Shooting = sum(as.numeric(shooting_incidents_total)),
            total_Robbery = sum(as.numeric(robbery_total)),
            total_Crimes = sum(as.numeric(total_number_of_incidents))
            )

totalByYear1 <- melt(totalByYear,id.var="year")

totalByYear2<- ggplot(totalByYear1,mapping = aes(year,value,fill=variable))+
  geom_histogram(stat="identity")+facet_grid(~variable)+
  guides(fill=F)+xlab("Years")+ylab("Total Crimes")+
  theme(axis.title=element_text(face="bold"))+
  ggtitle("Summary and Total Crimes Related to Riding in Tandem: 2011-2013")+
  theme_bw()+theme(plot.title = element_text(hjust = 0.5,face="bold",size=15))+
  theme(text=element_text(size=15))
  theme(axis.title=element_text(face="bold",size=15))
totalByYear3<- ggplot(totalByYear1,mapping = aes(year,value))+
  geom_histogram(stat="identity",position = "dodge",colour="black",aes(fill=variable))+
  xlab("Years")+ylab("Total Crimes")+
  ggtitle("Crimes Related to Riding in Tandem: 2011-2013")+
  theme_bw()+theme(legend.position="bottom")+
  theme(plot.title = element_text(hjust = 0.5,face="bold",size=15))+
  theme(axis.title=element_text(face="bold",size=15))+theme(text=element_text(size=15))+
  scale_fill_discrete(name="Legend  ",
                      labels=c("Other Crimes  ","Total Carnapping  ",
                              "Total Shooting  ","Total Robbery  ","Total Crime"))

perRegion <- s %>%
  select(police_regional_office,total_number_of_incidents)%>%
  filter(total_number_of_incidents>=0)%>%
  group_by(police_regional_office)%>%
  summarise(sumPerRegion= sum(as.numeric(total_number_of_incidents)))%>%
  arrange(sumPerRegion)

perRegion2 <- ggplot(perRegion,mapping = aes(police_regional_office,
                                             sumPerRegion,fill=police_regional_office))+
  geom_histogram(stat="identity")+
  theme(axis.title=element_text(face="bold"))+
  xlab("Regional Office")+xlim(c("COR","8","ARMM","4B",
                                 "13","2","6","9",
                                 "5","12","1","10",
                                 "11","7","4A","3","NCRPO"))+
  ylab("Total Incident")+guides(fill=F)+
  ggtitle("Total Crimes Related to Riding in Tandem: Per Region (2011-2013)")+
  theme_bw()+theme(plot.title = element_text(hjust = 0.5,face="bold",size=15))+
  theme(axis.title=element_text(face="bold",size=15))+theme(text=element_text(size=15))

