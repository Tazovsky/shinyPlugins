library(shinyPlugins)

header <- dashboardHeader(
  title = "Example Shiny app"
)

body <- dashboardBody(
  fluidRow(
    column(width = 9,
           box(width = NULL, solidHeader = TRUE,
               shinyPlugin_exampleUI("plugin1")
           ),
           box(width = NULL,
               "some example text"
           )
    )
  )
)

ui <- dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)

server <- function(input, output, session) {

  callModule(shinyPlugin_example, "plugin1")
}

shinyApp(ui = ui, server = server)
