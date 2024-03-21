#' <Add Title>
#'
#' <Add Description>
#'
#' @importFrom htmlwidgets createWidget
#' @importFrom htmltools htmlDependency
#'
#' @export
amMapChart <- function(
  projection = "Mercator",
  grid = list(step = 10, color = "black", opacity = 0.1),
  width = NULL, height = NULL, elementId = NULL
) {
  projections <- c(
    "equalEarth",
    "equirectangular",
    "Mercator",
    "naturalEarth1",
    "orthographic"
  )
  projection <- match.arg(projection, projections)
  geoProjections <- c(
    "geoEqualEarth",
    "geoEquirectangular",
    "geoMercator",
    "geoNaturalEarth1",
    "geoOrthographic"
  )
  names(geoProjections) <- projections

  # forward options using x
  x = list(
    projection = geoProjections[projection][[1L]],
    grid = grid
  )

  # create widget
  createWidget(
    name = "amMapChart",
    x,
    width = width,
    height = height,
    package = "amMapCharts5",
    elementId = elementId,
    dependencies = list(
      htmlDependency(
        name = "amcharts5",
        version = "5.8.6",
        src = "htmlwidgets/lib/amCharts5",
        script = c("index.js", "map.js"),
        package = "amMapCharts5"
      )
    )
  )
}

#' Shiny bindings for amMapChart
#'
#' Output and render functions for using amMapChart within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a amMapChart
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name amMapChart-shiny
#'
#' @export
#' @importFrom htmlwidgets shinyWidgetOutput shinyRenderWidget
amMapChartOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'amMapChart', width, height, package = 'amMapCharts5')
}

#' @rdname amMapChart-shiny
#' @export
renderAmMapChart <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, amMapChartOutput, env, quoted = TRUE)
}
