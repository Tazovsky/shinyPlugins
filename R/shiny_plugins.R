#' shiny_plugins
#'
#' Class providing object of \code{\link{R6Class}} to easily and automatically implement Shiny plugins (modules)
#'
#' @param ui.pattern prefix to find \strong{UI} functions of modules
#' @param server.pattern prefix to find \strong{server} functions of modules
#'
#' @return Object of \code{\link{R6Class}}
#' @docType class
#' @importFrom R6 R6Class
#' @author Kamil Foltyński
#' @export
#' @keywords plugins
#' @format \code{\link{R6Class}} object
#' @examples \dontrun{
#'   library(shinyPlugins)
#'   plugins <- shiny_plugins$new(where = ls("package:shinyPlugins"))
#' }
#'
#' @section Methods:
#' \describe{
#'   \item{\code{getPluginsList()}}{Get list of found plugins}
#'   \item{\code{getTabItems()}}{Get list of \code{\link[shinydashboard]{tabItem}} with content of plugins}
#'   \item{\code{getMenuItem()}}{Get \code{\link[shinydashboard]{menuItem}} containing plugins}
#'
#'   \item{\code{getModulesUI()}}{Get names of modules \strong{UI} functions}
#'   \item{\code{getModulesServer()}}{Get names of modules \strong{server} functions}
#'
#'   }
shiny_plugins <- R6::R6Class(
  "shinyPlugins",
  public = list(
    initialize = function(ui.pattern = "shinyPluginUI_",
                          server.pattern = "shinyPluginServer_",
                          where = ls(envir = parent.frame(2))) {


      futile.logger::flog.threshold(futile.logger::INFO, name = private$..logger_name)

      private$..ui.pattern <- ui.pattern
      private$..server.pattern <- server.pattern

      private$..where <- where

      shiny.plugins <- list()

      ui.modules <- where[base::grepl(paste0("^", ui.pattern), where)]
      server.modules <- where[base::grepl(paste0("^", server.pattern), where)]
      # cut off prefix
      names(ui.modules) <- gsub(paste0("^", ui.pattern), "", ui.modules)
      names(server.modules) <- gsub(paste0("^", server.pattern), "", server.modules)
      uniq.names <- unique(names(server.modules), names(ui.modules))

      for (nm in uniq.names) {
        futile.logger::flog.info(sprintf("parsing plugin's tabItem: %s", nm), name = private$..logger_name)

        ui.fun.name <- ui.modules[[nm]]
        server.fun.name <- server.modules[[nm]]

        private$..ui.part.of.module <- c(private$..ui.part.of.module, ui.fun.name)
        private$..server.part.of.module <- c(private$..server.part.of.module, server.fun.name)

        tab.name <- getTabItemName(nm)
        tab.id <- paste0(nm, "_ID")

        shiny.plugins[[ui.fun.name]] <- list(module_fun = ui.fun.name,
                                             module_server_fun = server.fun.name,
                                             args = list(id = tab.id),
                                             tab.name = tab.name)
      }

      menuItem <- menuItem("Plugins", icon = icon("plug"),
                           lapply(names(shiny.plugins), function(nm) {
                             menuSubItem(paste0("Plugin: ", nm), tabName = nm)
                           })
      )


      tab.items.list <- lapply(names(shiny.plugins), function(nm) {
        tabItem(
          # tab name
          tabName = nm,
          # content:
          do.call(shiny.plugins[[nm]]$module_fun, shiny.plugins[[nm]]$args)
        )
      })

      private$..tabItems <- tab.items.list
      private$..pluginsList <- shiny.plugins
      private$..menuItem <- menuItem
      private$..tabItemsNames <- names(shiny.plugins)
    },
    getPluginsList = function() {
      private$..pluginsList
    },
    getTabItems = function() {
        private$..tabItems
    },
    getMenuItem = function() {
      private$..menuItem
    },
    getModulesUI = function() {
      private$..ui.part.of.module
    },
    getModulesServer = function() {
      private$..server.part.of.module
    }
  ),
  private = list(
    ..menuItem = NULL,
    ..ui.pattern = NULL,
    ..server.pattern = NULL,
    ..server.part.of.module = NULL,
    ..ui.part.of.module = NULL,
    ..tabItems = list(),
    ..tabItemsNames = NULL,
    ..logger_name = "shinyPlugins",
    ..where = NULL,
    ..pluginsList = NULL,
    shared = {
      e <- new.env()
      e$envir <- e
      # return
      e
    }
  )
)


#' getTabItemName
#'
#' Get plugin's tab name
#'
#' @param name cahracter
#'
#' @return character
#'
getTabItemName <- function(name) {
  paste0(name, "_tab")
}
