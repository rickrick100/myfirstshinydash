library(shiny)
library(plotly)

source("Global.R")
shinyServer(function(input, output) {
   output$s <- renderPlotly({
     if(input$instate == "Per Region") {
       firstPlot
     } else if (input$instate == "Group Bar Chart"){
       secondPlot
     } else if (input$instate == "Suspects and Victims") {
       thirdPlot
     } else if (input$instate == "Shooting Incident") {
       fourthPlot1
     } else if (input$instate == "Robbery Incident") {
       fourthPlot2
     } else if (input$instate == "Carnapping Incident") {
       fourthPlot3
     } else if (input$instate == "Other Crimes") {
       fourthPlot4
     } else {
       fifthPlot
     }
   })
   #tables
   output$table <- renderDataTable(s)
})
