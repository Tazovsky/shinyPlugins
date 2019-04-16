# shinyPlugins

Shiny plugins in sense of this R package are Shiny modules which are automatically added
to Shiny app when their naming meets specified conditions.

## Installation

``` r
devtools::install_github("Tazovsky/shinyPlugins")
```

## Example

``` r
library(shinyPlugins)
plugins <- shiny_plugins$new(where = ls("package:shinyPlugins"))

# Run example Shiny app
shinyPlugins::runExample("02-plugins")
```

