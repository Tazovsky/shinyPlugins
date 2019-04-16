library(shinyPlugins)
futile.logger::flog.threshold(futile.logger::DEBUG)

ui <- dashboardPage(
  dashboardHeader(title = "shinyPlugins"),
  dashboardSidebar(
    sidebarMenu(
      id = "tabs",
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Widgets", tabName = "widgets", icon = icon("th"))
    )
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

  plugins <- shiny_plugins$new(where = ls("package:shinyPlugins"))

  observe({

    # -------------------------- insert menu tab(s)
    insertUI(
      selector = "#tabs",
      where = "afterEnd",
      ui = plugins$getMenuItem()
    )

    # -------------------------- insert tabs' content

    tabs.content <- plugins$getTabItems()

    for (i in 1:length(tabs.content)) {
      insertUI(
        selector = "#shiny-tab-dashboard",
        where = "afterEnd",
        ui = tabs.content[[i]]
      )
    }
  })

  # -------------------------- server part of modules
  plugins.list <- plugins$getPluginsList()
  server.side.part.of.plugins <- lapply(names(plugins.list), function(nm) {
    plugin <- plugins.list[[nm]]
    futile.logger::flog.debug(sprintf("Running server side of module: %s", plugin$module_server_fun))
    callModule(get(plugin$module_server_fun), plugin$args$id)
  })

}

shinyApp(ui, server)
