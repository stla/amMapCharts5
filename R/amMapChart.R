geoProjections <- function() {
  projections <- c(
    "equalEarth",
    "equirectangular",
    "Mercator",
    "naturalEarth1",
    "orthographic"
  )
  gProjections <- c(
    "geoEqualEarth",
    "geoEquirectangular",
    "geoMercator",
    "geoNaturalEarth1",
    "geoOrthographic"
  )
  names(gProjections) <- projections
  gProjections
}

#' Chart widget
#' @description Initiates an \code{amMapChart} widget.
#'
#' @param projection the projection, one choice among \code{"equalEarth"},
#'  \code{"equirectangular"}, \code{"Mercator"}, \code{"naturalEarth1"} or
#'  \code{"orthographic"}
#' @param grid list of settings for the grid; set to \code{NULL} for no grid
#' @param width,height dimensions
#' @param elementId a HTML id (usually useless)
#'
#' @returns An \code{amMapChart} widget.
#'
#' @export
#' @importFrom htmlwidgets createWidget
#'
#' @examples
#' library(amMapCharts5)
#' world <-
#'   system.file("geojson", "worldLow.json", package = "amMapCharts5")
#' amMapChart(projection = "orthographic") %>%
#'   addPolygons(world, color = "red", strokeColor = "black")
amMapChart <- function(
  projection = "Mercator",
  grid = list(step = 10, color = "black", opacity = 0.1),
  width = NULL, height = NULL, elementId = NULL
) {
  gProjections <- geoProjections()
  projections <- names(gProjections)
  projection <- match.arg(projection, projections)

  # forward options using x
  x = list(
    projection = gProjections[projection][[1L]],
    grid = grid
  )

  # create widget
  createWidget(
    name = "amMapChart",
    x,
    width = width,
    height = height,
    package = "amMapCharts5",
    elementId = elementId
    # dependencies = list(
    #   htmlDependency(
    #     name = "amcharts5",
    #     version = "5.8.6",
    #     src = "htmlwidgets/lib/amCharts5",
    #     script = c("index.js", "map.js", "exporting.js"),
    #     package = "amMapCharts5"
    #   )
    # )
  )
}

#' Shiny bindings for 'amMapChart'
#'
#' @description Output and render functions for using \code{amMapChart} within
#'   Shiny applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height a valid CSS dimension (like \code{"100\%"},
#'   \code{"400px"}, \code{"auto"}) or a number, which will be coerced to a
#'   string and have \code{"px"} appended
#' @param expr an expression that generates an \code{\link{amMapChart}}
#' @param env the environment in which to evaluate \code{expr}
#' @param quoted logical, whether \code{expr} is a quoted expression
#'   (with \code{quote()}); this is useful if you want to save an expression
#'   in a variable
#'
#' @returns \code{amMapChartOutput} returns an output element that can be
#'   included in a Shiny UI definition, and \code{renderAmMapChart} returns a
#'   \code{shiny.render.function} object that can be included in a Shiny server
#'   definition.
#'
#' @name amMapChart-shiny
#'
#' @export
#' @importFrom htmlwidgets shinyWidgetOutput shinyRenderWidget
amMapChartOutput <- function(outputId, width = "100%", height = "400px"){
  shinyWidgetOutput(
    outputId, 'amMapChart', width, height, package = 'amMapCharts5'
  )
}

#' @rdname amMapChart-shiny
#' @export
renderAmMapChart <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, amMapChartOutput, env, quoted = TRUE)
}

#' Update an 'amMapChart' in Shiny
#' @description Update an \code{amMapChart} widget in a Shiny app.
#'
#' @param session the Shiny session object
#' @param inputId the id of the \code{amMapChart} widget to be updated
#' @param projection the new projection
#'
#' @return No returned value.
#' @export
#'
#' @examples
#' if(require("shiny") && interactive()) {
#'
#' library(amMapCharts5)
#' library(shiny)
#'
#' world <-
#'   system.file("geojson", "worldLow.json", package = "amMapCharts5")
#' line <- rbind(
#'   c(-73.778137, 40.641312),
#'   c(-0.454296, 51.470020),
#'   c(116.597504, 40.072498)
#' )
#' map <- amMapChart(projection = "Mercator") %>%
#'   addPolygons(world, color = "red", strokeColor = "black") %>%
#'   addLineWithPlane(line, planePosition = 0.2, color = "lime", width = 2)
#'
#' ui <- fluidPage(
#'   sidebarLayout(
#'     sidebarPanel(
#'       radioButtons(
#'         "projection",
#'         label = "Projection",
#'         choices = c(
#'           "equalEarth",
#'           "equirectangular",
#'           "Mercator",
#'           "naturalEarth1",
#'           "orthographic"
#'         ),
#'         selected = "Mercator"
#'       )
#'     ),
#'     mainPanel(
#'       br(),
#'       amMapChartOutput("map")
#'     )
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'
#'   output[["map"]] <- renderAmMapChart({
#'     map
#'   })
#'
#'   observeEvent(input[["projection"]], {
#'     updateAmMapChart(session, "map", projection = input[["projection"]])
#'   }, ignoreInit = TRUE)
#'
#' }
#'
#' shinyApp(ui, server)
#' }
updateAmMapChart <- function(session, inputId, projection) {
  gProjections <- geoProjections()
  projections  <- names(gProjections)
  projection   <- match.arg(projection, projections)
  gProjection  <- gProjections[projection][[1L]]
  session$sendCustomMessage(
    paste0("update_", inputId), list("projection" = gProjection)
  )
}

