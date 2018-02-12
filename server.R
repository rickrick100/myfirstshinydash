library(shinythemes)
library(shiny)
source("graph.R")
shinyServer(function(input, output) {
   output$s <- renderPlot({
     if(input$instate == "Facet of Crimes") {
       totalByYear2
     } else if (input$instate == "Group Bar Chart")  {
       totalByYear3
     } else {
       perRegion2
     }
   })
   output$table <- renderDataTable(s)

})
