#' runExample
#'
#' Run example Shiny App
#'
#' @param example
#'
#' @export
#' @author Kamil Foltyński
#' @examples \dontrun{
#'   shinyPlugins::runExample("02-plugins")
#' }
runExample <- function(example = "02-plugins") {

  examples <- paste(list.files(system.file("examples",
                                           package = "shinyPlugins")))

  validExamples <- paste0("Valid examples are: \"", paste(examples, collapse = "\", \""), "\"")
  if (missing(example) || !nzchar(example)) {
    message("Please run `runExample()` with a valid example app as an argument.\n",
            validExamples)

    return(invisible(NULL))
  }
  appDir <- system.file("examples", example, package = "shinyPlugins")
  shiny::runApp(appDir, display.mode = "normal")
}
