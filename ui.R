library(DT)
library(shinydashboard)

dashboardPage(
  skin = "green",
  dashboardHeader(title="My Dashboard"),
  dashboardSidebar(    
      sidebarMenu(
      menuItem("Introduction", tabName = "Intro", icon = icon("th")),
      menuItem("Graphs", tabName = "Graphs", icon = icon("equalizer", lib = "glyphicon")),
      menuItem("Data", tabName = "Data", icon = icon("file", lib = "glyphicon"))
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),
    tabItems(
      tabItem(tabName = "Intro",
              img(src='asd.png')
      ),
      #2nd tab
      tabItem(tabName = "Graphs",
              fluidRow(
                box(width = 9, title = "Chart", status = "info", solidHeader = TRUE,
                  (plotlyOutput("s", height = 450))
                ),
                box(width=3,
                  title = "Controls",status = "danger", solidHeader = TRUE,
                  selectInput("instate", "Select a Chart:", choices = c("Per Region","Group Bar Chart","Suspects and Victims",
                                                                        "Shooting Incident","Robbery Incident","Carnapping Incident",
                                                                        "Other Crimes","Status of Cases"))
                )
              )
      ),
      
      #3rd tab
      tabItem(tabName = "Data",
              box(
                title = "Dataset", status = "success", solidHeader = TRUE,width=12,
              div(style = 'overflow-x: scroll', DT::dataTableOutput('table'))
              ),
              fluidRow(
                box(
                  title = "Link to Dataset", status = "primary", solidHeader = TRUE,
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
