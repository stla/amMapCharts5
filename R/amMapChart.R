#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#' @importFrom htmltools htmlDependency
#'
#' @export
amMapChart <- function(
  projection = "Mercator", width = NULL, height = NULL, elementId = NULL
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
    projection = geoProjections[projection]
  )

  # create widget
  htmlwidgets::createWidget(
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

#' Shiny bindings for amChartMap
#'
#' Output and render functions for using amChartMap within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a amChartMap
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name amChartMap-shiny
#'
#' @export
amChartMapOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'amChartMap', width, height, package = 'amMapCharts5')
}

#' @rdname amChartMap-shiny
#' @export
renderAmChartMap <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, amChartMapOutput, env, quoted = TRUE)
}
