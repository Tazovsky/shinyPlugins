
getTabItemName <- function(name) {
  paste0(name, "_tab")
}

shiny_plugins <- R6::R6Class(
  "shinyPlugins",
  public = list(
    initialize = function(pattern = "^shinyPlugin_.*UI$", where = ls(envir = parent.frame(2))) {

      futile.logger::flog.threshold(futile.logger::INFO, name = private$..logger_name)

      private$..pattern <- pattern
      private$..where <- where

      shiny.plugins <- list()

      for (nm  in where) {
        # nm <- "shinyPlugin_exampleUI"
        if (base::grepl("^shinyPlugin_.*UI$", nm)) {
          futile.logger::flog.info(sprintf("parsing plugin's tabItem: %s", nm), name = private$..logger_name)

          tab.name <- getTabItemName(nm)
          tab.id <- paste0(nm, "_ID")

          shiny.plugins[[tab.name]] <- list(module_fun = nm, args = list(id = tab.id), tab.name = tab.name)

        }
      }

      menuItem <- menuItem("Plugins", icon = icon("bar-chart-o"),
                           # list(
                           #   menuSubItem("Sub-item 1", tabName = "subitem1"),
                           #   menuSubItem("Sub-item 2", tabName = "subitem2")
                           # )
                           lapply(names(shiny.plugins), function(nm) {
                             menuSubItem(paste0("Plugin: ", nm), tabName = nm)
                           })
      )

      # browser()

      tab.items.list <- lapply(names(shiny.plugins), function(nm) {
        # quote({
        tabItem(
          # tab name
          tabName = nm,
          # content:
          do.call(shiny.plugins[[nm]]$module_fun, shiny.plugins[[nm]]$args)
        )
        # })
      })

      # tab.items.text.to.eval <- sprintf("tabItems(\n%s)", paste0(unlist(tab.items.list), collapse = ",\n"))
      # tab.items.text.to.eval <- paste0(unlist(tab.items.list), collapse = ",\n")
      # tab.items.text.to.eval <- tab.items.list
      private$..tabItems <- tab.items.list

      private$..pluginsList <- shiny.plugins
      private$..menuItem <- menuItem
      private$..tabItemsNames <- names(shiny.plugins)
    },
    getPluginsList = function() {
      private$..pluginsList
    },
    getTabItems = function(eval = FALSE) {
      if (eval) {
        eval(parse(text = private$..tabItems))
        browser()
        res <- lapply(private$..tabItems, function(x) eval(parse(text = x)))
        unlist(res)
      } else
        private$..tabItems
    },
    getMenuItem = function() {
      private$..menuItem
    }
  ),
  private = list(
    ..menuItem = NULL,
    ..pattern = NULL,
    ..tabItems = list(),
    ..tabItemsNames = NULL,
    ..logger_name = "shinyPlugins",
    ..where = NULL,
    ..pluginsList = NULL,
    # great tips: https://elvinouyang.github.io/study%20notes/oop-with-r-s3-and-r6/ #nolint
    shared = {
      e <- new.env()
      e$envir <- e
      # return
      e
    }
  )
)

# if (interactive())
#   plugins <- shiny_plugins$new(where = ls("package:shinyPlugins"))
# plugins$getPluginsList()
# plugins$getTabItems()
# plugins$getMenuItem()


#
# plugins$getTabItems()
#
# res <- plugins$getTabItems()
# res[[1]]
#
# x <- res[[1]]
# class(x)
# str(x)
#
#
# substitute(res[[1]], res[[2]])

