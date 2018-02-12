library(shinythemes)
library(shinydashboard)
library(DT)

dashboardPage(
  dashboardHeader(title="My Dashboard"),
  dashboardSidebar(    
      sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Widgets", tabName = "widgets", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      #2nd tab
      tabItem(tabName = "dashboard",
              fluidRow(
                lol<-box(width = 9,title = "Chart", status = "primary", solidHeader = TRUE,
                  (plotOutput("s", height = 500))
                ),
                box(width=3,
                  title = "Controls",status = "warning", solidHeader = TRUE,
                  selectInput("instate", "Select a field to Create a Barchart:", choices = c("Per Region","Facet of Crimes","Group Bar Chart"))
                )
              )
      ),
      
      #2nd tab
      tabItem(tabName = "widgets",
              div(style = 'overflow-x: scroll', DT::dataTableOutput('table')),br(),
              fluidRow(
                box(
                  title = "Download", status = "warning", solidHeader = TRUE,
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
