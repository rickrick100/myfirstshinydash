library(shinythemes)
library(shinydashboard)
library(DT)

dashboardPage(
  dashboardHeader(title="My Dashboard"),
  dashboardSidebar(    
      sidebarMenu(
      menuItem("Graphs", tabName = "Graphs", icon = icon("equalizer", lib = "glyphicon")),
      menuItem("Data", tabName = "Data", icon = icon("file", lib = "glyphicon"))
    )
  ),
  dashboardBody(
    tabItems(
      #2nd tab
      tabItem(tabName = "Graphs",
              fluidRow(
                lol<-box(width = 9,title = "Chart", status = "primary", solidHeader = TRUE,
                  (plotOutput("s", height = 450))
                ),
                box(width=3,
                  title = "Controls",status = "warning", solidHeader = TRUE,
                  selectInput("instate", "Select a field to Create a Barchart:", choices = c("Per Region","Facet of Crimes","Group Bar Chart"))
                )
              ),
              fluidRow(
                box(tableOutput("table1"),width=4),
                box(tableOutput("table2"),width=8)
              )
              
              
      ),
      
      #2nd tab
      tabItem(tabName = "Data",
              div(style = 'overflow-x: scroll', DT::dataTableOutput('table')),br(),
              fluidRow(
                box(
                  title = "Link to Dataset", status = "warning", solidHeader = TRUE,
                  a("https://data.gov.ph/dataset/recapitulation-incidents-involving-motorcycle-riding-tandem-criminals")
                ),
                box(
                  title = "Github", status = "primary", solidHeader = TRUE,
                  p("Source Code link"),
                  a("https://github.com/rickrick100/myfirstshinydash")
                  
                )
                    
              )
      )
    )
  )
)
