library(readr)
library(ggplot2)
library(plotly)
library(dplyr)
library(shiny)
library(data.table)
library(rsconnect)
library(shinydashboard)
library(zoo)
library(lubridate)

#Read CSV file
s <- read.csv('s.csv',stringsAsFactors = F)
s <- data.table(s)

#Cleaning " - " and filtering 0 values
s[s== " - "] <- 0
sfilter <- s %>%
  filter(total_number_of_incidents > 0)

#variables Used
t <- list(
  family = "Calibri",
  size = 16)

arrangement <- c("NCRPO","3","4A","7","11","10","1","12","5","9","6",
                 "2","13","4B","ARMM","8","COR")

xform <- list(categoryorder ="array",
              categoryarray = arrangement,
              title = "Police Regional Office")

arrangements <- c(2011:2013)

xforms <- list(categoryorder ="array",
              categoryarray = arrangements,
              title = "Year")

#PLOTTING
firstPlot <- sfilter %>%
  select(police_regional_office,total_number_of_incidents)%>%
  group_by(police_regional_office)%>%
  summarize(totalCrimes = sum(as.numeric(total_number_of_incidents)))%>%
  arrange(totalCrimes)%>%
  plot_ly(x = ~police_regional_office, y = ~totalCrimes, type = 'bar') %>%
  layout(title = "Riding in Tandem Total Incident: Per Region",
         xaxis = xform,
         yaxis = list(title = "Total Crimes",range = c(0,1800)),
         showlegend = F,
         font = t)

secondPlot <- s %>%
  select(year,shooting_incidents_total,robbery_total,
         carnapping_total,others_total,total_number_of_incidents)%>%
  group_by(year)%>%
  summarize(othersTotal = sum(as.numeric(others_total)),
          carnappingTotal = sum(as.numeric(carnapping_total)),
          robberyTotal = sum(as.numeric(robbery_total)),
          shootingTotal = sum(as.numeric(shooting_incidents_total)),
          totalIncident = sum(as.numeric(total_number_of_incidents)))%>%
  plot_ly(x = ~year, y = ~othersTotal, type = 'bar',name="Other Crimes") %>%
  add_trace(y = ~carnappingTotal, name="Carnapping") %>%
  add_trace(y = ~shootingTotal, name="Shooting") %>%
  add_trace(y = ~robberyTotal, name="Robbery") %>%
  add_trace(y = ~totalIncident, name="Total") %>%
  layout(yaxis = list(title = 'Count'),
         xaxis = list(title = 'Year'),
         title = ("Crimes related to Riding in Tandem: 2011-2013"),
         font = t,
         barmode = 'group')

thirdPlot <- s %>%
  select(year,victims_total,status_of_suspects_arrested,
         status_of_suspects_at_large,
         victims_total,status_of_suspects_total,status_of_suspects_killed,
         total_number_of_incidents)%>%
  group_by(year)%>%
  summarize(victimsTotal = sum(as.numeric(victims_total)),
            suspectSF = sum(as.numeric(status_of_suspects_at_large)),
            suspectsArrested = sum(as.numeric(status_of_suspects_arrested)),
            suspectKilled = sum(as.numeric(status_of_suspects_killed)),
            totalIncident = sum(as.numeric(total_number_of_incidents)))%>%
    plot_ly(x = ~year, y = ~victimsTotal, name = 'Total Victims', type = 'scatter', mode = 'lines+markers',
          line = list(color = '#9b59b6')) %>%
    add_trace(y = ~totalIncident, name = 'Total # of Incident', line = list(color = '#e74c3c'))%>%
    add_trace(y = ~suspectsArrested, name = 'Suspects Arrested', line = list(color = '#2ecc71')) %>%
    add_trace(y = ~suspectKilled, name = 'Suspects Killed', line = list(color = '#f1c40f'))%>%
    add_trace(y = ~suspectSF, name = 'Suspects Not Yet Arrested', line = list(color = '#34495e'))%>%
    layout(yaxis = list(title = 'Count'),
           xaxis = list(title = 'Year'),
           title = ("Suspects and Victims"),
           font = t)

fourthPlot <- s %>%
  select(year, month, shooting_incidents_killed:shooting_incidents_unharmed,
         robbery_killed:robbery_unharmed,carnapping_killed:carnapping_unharmed,
         others_killed:others_unharmed)%>%
  group_by(year,month)%>%
  summarize(shootingKilled = sum(as.numeric(shooting_incidents_killed)),
            shootingWounded = sum(as.numeric(shooting_incidents_wounded)),
            shootingUnharmed = sum(as.numeric(shooting_incidents_unharmed)),
            robberyKilled = sum(as.numeric(robbery_killed)),
            robberyWounded = sum(as.numeric(robbery_wounded)),
            robberyUnharmed = sum(as.numeric(robbery_unharmed)),
            carnappingKilled = sum(as.numeric(carnapping_killed)),
            carnappingWounded = sum(as.numeric(carnapping_wounded)),
            carnappingUnharmed = sum(as.numeric(carnapping_unharmed)),
            othersKilled = sum(as.numeric(others_killed)),
            othersWounded = sum(as.numeric(others_wounded)),
            othersUnharmed = sum(as.numeric(others_unharmed)))

fourthPlot$month <- factor(fourthPlot$month,
                           levels=c("January","February","March","April",
                                    "May","June","July","August",
                                    "September","October","November","December"),
                           labels=c("01","02","03","04","05","06",
                                    "07","08","09","10","11","12"))

fourthPlot <- fourthPlot%>%
  arrange(year,month)

fourthPlot1 <- plot_ly(data=fourthPlot,
  x = ~month,
  y = ~shootingKilled,
  frame = ~year,
  name = "Killed",
  type = 'scatter', mode = 'lines+markers',
  showlegend = F)%>%
  add_trace(y = ~shootingWounded, name = 'Wounded', line = list(color = '#34495e')) %>%
  add_trace(y = ~shootingUnharmed, name = 'Unharmed', line = list(color = '#e74c3c'))%>%
  layout(yaxis = list(title = 'Shooting Incidents'),
         xaxis = list(title = 'Month'),
         title = ("Shooting Incidents: 2011-2013"),
         font = t)%>%
  animation_opts(
    1000, easing="linear", redraw = FALSE)%>%
  animation_slider(
    currentvalue = list(prefix = "YEAR ", font = list(color="blue"))
    )

fourthPlot2 <-plot_ly(data=fourthPlot,
        x = ~month,
        y = ~robberyKilled,
        frame = ~year,
        name = "Killed",
        type = 'scatter', mode = 'lines+markers',
        showlegend = F)%>%
  add_trace(y = ~robberyWounded, name = 'Wounded', line = list(color = '#34495e')) %>%
  add_trace(y = ~robberyUnharmed, name = 'Unharmed', line = list(color = '#e74c3c'))%>%
  layout(yaxis = list(title = 'Robbery Incidents'),
         xaxis = list(title = 'Month'),
         title = ("Robbery Incidents: 2011-2013"),
         font = t)%>%
  animation_opts(
    1000, easing="linear", redraw = FALSE)%>%
  animation_slider(
    currentvalue = list(prefix = "YEAR ", font = list(color="blue"))
  )

fourthPlot3 <-plot_ly(data=fourthPlot,
        x = ~month,
        y = ~carnappingKilled,
        frame = ~year,
        name = "Killed",
        type = 'scatter', mode = 'lines+markers',
        showlegend = F)%>%
  add_trace(y = ~carnappingWounded, name = 'Wounded', line = list(color = '#34495e')) %>%
  add_trace(y = ~carnappingUnharmed, name = 'Unharmed', line = list(color = '#e74c3c'))%>%
  layout(yaxis = list(title = 'Carnapping Incidents'),
         xaxis = list(title = 'Month'),
         title = ("Carnapping Incidents: 2011-2013"),
         font = t)%>%
  animation_opts(
    1000, easing="linear", redraw = FALSE)%>%
  animation_slider(
    currentvalue = list(prefix = "YEAR ", font = list(color="blue"))
  )

fourthPlot4 <- plot_ly(data=fourthPlot,
        x = ~month,
        y = ~othersKilled,
        frame = ~year,
        name = "Killed",
        type = 'scatter', mode = 'lines+markers',
        showlegend = F)%>%
  add_trace(y = ~othersWounded, name = 'Wounded', line = list(color = '#34495e')) %>%
  add_trace(y = ~othersUnharmed, name = 'Unharmed', line = list(color = '#e74c3c'))%>%
  layout(yaxis = list(title = 'Other Crime Incidents'),
         xaxis = list(title = 'Month'),
         title = ("Other Crime Incidents: 2011-2013"),
         font = t)%>%
  animation_opts(
    1000, easing="linear", redraw = FALSE)%>%
  animation_slider(
    currentvalue = list(prefix = "YEAR ", font = list(color="blue"))
  )

fifthPlot <- s %>%
  select(year,status_of_case_under_investigation:status_of_case_no_case_filed) %>%
  group_by(year)%>%
  summarize(caseUI = sum(as.numeric(status_of_case_under_investigation)),
            caseRP = sum(as.numeric(status_of_case_referred_to_pros)),
            caseFIC = sum(as.numeric(status_of_case_filed_in_court)),
            caseNCF = sum(as.numeric(status_of_case_no_case_filed)))%>%
  plot_ly(x = ~year, y = ~caseNCF, type = 'bar',name="No case filed") %>%
  add_trace(y = ~caseFIC, name="Filed in Court") %>%
  add_trace(y = ~caseRP, name="Referred to Prosecution") %>%
  add_trace(y = ~caseUI, name="Under Investigation") %>%
  layout(yaxis = list(title = 'Count'),
         xaxis = list(title = 'Year'),
         title = ("Status of Cases related to Riding in Tandem"),
         font = t,
         barmode = 'group')