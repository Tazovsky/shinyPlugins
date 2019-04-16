#' shinyPlugin_exampleUI
#'
#' @param id
#'
#' @export
#' @rdname shinyPlugin_example
shinyPluginUI_example <- function(id) {
  stopifnot(!missing(id))
  ns <- shiny::NS(id)
  fluidPage(
    plotlyOutput(ns("plot")),
    verbatimTextOutput(ns("event"))
  )
}

#' shinyPlugin_example
#'
#'
#' @param input
#' @param output
#' @param session
#'
#' @export
#' @rdname shinyPlugin_example
shinyPluginServer_example <- function(input, output, session) {

  output$plot <- renderPlotly({
    plot_ly(mtcars, x = ~mpg, y = ~wt)
  })

  output$event <- renderPrint({
    d <- event_data("plotly_hover")
    if (is.null(d)) "Hover on a point!" else d
  })

}


#' shinyPlugin_example2UI
#'
#' @param id
#'
#' @export
#' @rdname shinyPlugin_example2
shinyPluginUI_example2 <- function(id) {
  stopifnot(!missing(id))
  ns <- shiny::NS(id)
  fluidPage(
    plotlyOutput(ns("plot")),
    verbatimTextOutput(ns("event"))
  )
}

#' shinyPlugin_example2
#'
#' @param input
#' @param output
#' @param session
#'
#' @export
#' @rdname shinyPlugin_example2
shinyPluginServer_example2 <- function(input, output, session) {

  output$plot <- renderPlotly({
    plot_ly(mtcars, x = ~mpg, y = ~wt)
  })

  output$event <- renderPrint({
    d <- event_data("plotly_hover")
    if (is.null(d)) "Hover on a point!" else d
  })

}
