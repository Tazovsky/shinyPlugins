library(shinyPlugins)

ui <- dashboardPage(
  dashboardHeader(title = "Simple tabs"),
  dashboardSidebar(
    sidebarMenu(
      id = "tabs",
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Widgets", tabName = "widgets", icon = icon("th"))
    ),
      actionButton('switchtab', 'Switch tab')
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              h2("Dashboard tab content")
      ),
      tabItem(tabName = "widgets",
              h2("Widgets tab content")
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$switchtab, {
    newtab <- switch(input$tabs,
                     "dashboard" = "widgets",
                     "widgets" = "dashboard"
    )
    updateTabItems(session, "tabs", newtab)
  })

  observe({

    plugins <- shiny_plugins$new(where = ls("package:shinyPlugins"))

    # -------------------------- insert menu tab(s)
    insertUI(
      selector = "#tabs",
      where = "afterEnd",
      ui = plugins$getMenuItem()
    )

    # -------------------------- insert tabs' content
    # browser()

    tabs.content <- plugins$getTabItems()

    for (i in 1:length(tabs.content)) {
      insertUI(
        selector = "#shiny-tab-dashboard",
        where = "afterEnd",
        ui = tabs.content[[i]]
      )
    }
  })

}

shinyApp(ui, server)
