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
#' @param panX,panY see \href{https://www.amcharts.com/docs/v5/charts/map-chart/map-pan-zoom/#Panning}{Panning}
#' @param grid list of settings for the grid (see the default value); set to
#'   \code{NULL} for no grid
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
#' amMapChart("orthographic", panX = "rotateX", panY = "rotateY") %>%
#'   addPolygons(world, color = "red", strokeColor = "black")
amMapChart <- function(
  projection = "Mercator", panX = "translateX", panY = "translateY",
  grid = list(step = 10, color = "black", opacity = 0.2),
  elementId = NULL
) {
  panX <- match.arg(panX, c("none", "translateX", "rotateX"))
  panY <- match.arg(panY, c("none", "translateY", "rotateY"))

  gProjections <- geoProjections()
  projections  <- names(gProjections)
  projection   <- match.arg(projection, projections)

  # forward options using x
  grid[["color"]] <- validateColor(grid[["color"]])
  x = list(
    projection = gProjections[projection][[1L]],
    panX       = panX,
    panY       = panY,
    grid       = grid
  )

  # create widget
  createWidget(
    name      = "amMapChart",
    x,
    width     = NULL,
    height    = NULL,
    package   = "amMapCharts5",
    elementId = elementId
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
#' @param panX the new \code{panX} value
#' @param panY the new \code{panY} value
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
#' map <- amMapChart("Mercator", panX = "translateX", panY = "translateY") %>%
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
#'       ),
#'       radioButtons(
#'         "panX",
#'         label = "Horizontal dragging (panX)",
#'         choices = c(
#'           "translateX",
#'           "rotateX"
#'         ),
#'         selected = "translateX"
#'       ),
#'       radioButtons(
#'         "panY",
#'         label = "Vertical dragging (panY)",
#'         choices = c(
#'           "translateY",
#'           "rotateY"
#'         ),
#'         selected = "translateY"
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
#'   observeEvent(input[["panX"]], {
#'     updateAmMapChart(session, "map", panX = input[["panX"]])
#'   }, ignoreInit = TRUE)
#'
#'   observeEvent(input[["panY"]], {
#'     updateAmMapChart(session, "map", panY = input[["panY"]])
#'   }, ignoreInit = TRUE)
#'
#' }
#'
#' shinyApp(ui, server)
#' }
updateAmMapChart <- function(
    session, inputId, projection = NULL, panX = NULL, panY = NULL
) {
  if(!is.null(projection)) {
    gProjections <- geoProjections()
    projections  <- names(gProjections)
    projection   <- match.arg(projection, projections)
    projection   <- gProjections[projection][[1L]]
  }
  if(!is.null(panX)) {
    panX <- match.arg(panX, c("none", "translateX", "rotateX"))
  }
  if(!is.null(panY)) {
    panY <- match.arg(panY, c("none", "translateY", "rotateY"))
  }
  message <- Filter(
    Negate(is.null),
    list("projection" = projection, "panX" = panX, "panY" = panY)
  )
  session$sendCustomMessage(
    paste0("update_", inputId), message
  )
}

