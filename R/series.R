#' Add polygons to a map
#' @description Add some polygons to an \code{amMapChart}.
#'
#' @param map an \code{amMapChart} widget
#' @param coordinates for a single polygon, this can be a numeric matrix with
#'   two columns or a dataframe having two columns \code{longitude} and
#'   \code{latitude}; for multiple polygons, a list of such matrices or
#'   dataframes; or the path to a \strong{geojson} file
#' @param tooltipKey if \code{coordinates} is given by a \strong{geojson} file,
#'   the name of a property whose value will appear in tooltips
#' @param color fill color
#' @param opacity opacity, a number between 0 and 1
#' @param strokeColor stroke color
#' @param strokeWidth stroke width
#'
#' @return An \code{amMapChart} widget.
#' @export
#'
#' @note A color can be given by the name of a R color, the name of a CSS
#'   color, e.g. \code{"crimson"} or \code{"fuchsia"}, an HEX code like
#'   \code{"#ff009a"}, a RGB code like \code{"rgb(255,100,39)"}, or a HSL code
#'   like \code{"hsl(360,11,255)"}.
#'
#' @examples
#' library(amMapCharts5)
#' world <-
#'   system.file("geojson", "worldLow.json", package = "amMapCharts5")
#' amMapChart() %>%
#'   addPolygons(
#'     world, tooltipKey = "name", color = "red", strokeColor = "black"
#'   )
addPolygons <- function(
    map, coordinates, tooltipKey = NULL,
    color = "springgreen", opacity = 1,
    strokeColor = "black", strokeWidth = NULL
) {
  geojson <- NULL
  data    <- NULL
  if(is.character(coordinates)) {
    geojson <- paste0(suppressWarnings(readLines(coordinates)), collapse = "\n")
  } else {
    if(is.matrix(coordinates) || is.data.frame(coordinates)) {
      coordinates <- list(coordinates)
    }
    data <- lapply(coordinates, function(M) {
      if(is.data.frame(M)) {
        M <- as.matrix(M[, c("longitude", "latitude")])
      }
      list(
        geometry = list(
          "type"        = "Polygon",
          "coordinates" = array(M, dim = c(1L, nrow(M), 2L))
        )
      )
    })
  }
  series <- map[["x"]][["series"]] %||% list()
  series[[length(series) + 1L]] <- list(
    "type"    = "MapPolygonSeries",
    "data"    = data,
    "geojson" = geojson,
    "options" = emptyNamedList,
    "style"   =  list(
      "fill"        = validateColor(color),
      "stroke"      = validateColor(strokeColor),
      "strokeWidth" = strokeWidth,
      "fillOpacity" = opacity,
      "tooltipText" = if(!is.null(tooltipKey)) sprintf("{%s}", tooltipKey)
    )
  )
  map[["x"]][["series"]] <- series
  map
}

#' Add points to a map
#' @description Add some points to an \code{amMapChart}.
#'
#' @param map an \code{amMapChart} widget
#' @param coordinates this can be a matrix with two columns, or a dataframe
#'    having two columns \code{longitude} and \code{latitude} and optionally
#'    a column \code{name} for the tooltips, or the path to a \strong{geojson}
#'    file
#' @param bullet list of settings for the bullets created with
#'   \code{\link{amCircle}}, \code{\link{amTriangle}} or \code{\link{amRectangle}}
#'
#' @return An \code{amMapChart} widget.
#' @export
#'
#' @examples
#' library(amMapCharts5)
#' continents <-
#'   system.file("geojson", "continentsLow.json", package = "amMapCharts5")
#' amMapChart() %>%
#'   addPolygons(continents, color = "orange", strokeColor = "black") %>%
#'   addPoints(cities, amCircle(color = "black", radius = 3))
addPoints <- function(
    map, coordinates, bullet = amCircle("darkred")
) {
  geojson <- NULL
  data    <- NULL
  if(is.character(coordinates)) {
    geojson <- paste0(suppressWarnings(readLines(coordinates)), collapse = "\n")
  } else {
    if(is.matrix(coordinates)) {
      colnames(coordinates) <- c("longitude", "latitude")
      coordinates <- as.data.frame(coordinates)
    }
    if(!is.element("name", colnames(coordinates))) {
      coordinates[["name"]] <- NA
    } else {
      bullet[["options"]][["tooltipY"]]    <- 0L
      bullet[["options"]][["tooltipText"]] <- "{name}"
    }
    coordinates <- unname(split(coordinates, 1L:nrow(coordinates)))
    data <- lapply(coordinates, function(row) {
      list(
        geometry = list(
          "type"        = "Point",
          "coordinates" = as.numeric(row[, c("longitude", "latitude")])
        ),
        name = row[["name"]]
      )
    })
  }
  series <- map[["x"]][["series"]] %||% list()
  series[[length(series) + 1L]] <- list(
    "type"    = "MapPointSeries",
    "data"    = data,
    "geojson" = geojson,
    "options" = emptyNamedList,
    "bullet"  = bullet
  )
  map[["x"]][["series"]] <- series
  map
}

#' Add lines to a map
#' @description Add some lines to an \code{amMapChart}.
#'
#' @param map an \code{amMapChart} widget
#' @param coordinates for a single line, this can be a numeric matrix with
#'   two columns or a dataframe having two columns \code{longitude} and
#'   \code{latitude}; for multiple lines, a list of such matrices or
#'   dataframes; or the path to a \strong{geojson} file
#' @param lineType type of the line, \code{"curved"} or \code{"straight"}
#' @param color line color
#' @param opacity line opacity, a number between 0 and 1
#' @param width line width
#'
#' @return An \code{amMapChart} widget.
#' @export
#'
#' @note A color can be given by the name of a R color, the name of a CSS
#'   color, e.g. \code{"lime"} or \code{"indigo"}, an HEX code like
#'   \code{"#ff009a"}, a RGB code like \code{"rgb(255,100,39)"}, or a HSL code
#'   like \code{"hsl(360,11,255)"}.
#'
#' @examples
#' library(amMapCharts5)
#' continents <-
#'   system.file("geojson", "continentsLow.json", package = "amMapCharts5")
#' line <- rbind(
#'   c(-73.778137, 40.641312),
#'   c(-0.454296, 51.470020),
#'   c(116.597504, 40.072498)
#' )
#' amMapChart() %>%
#'   addPolygons(continents, color = "orange", strokeColor = "black") %>%
#'   addLines(line, color = "purple", width = 3)
addLines <- function(
    map, coordinates, lineType = "curved",
    color = "red", opacity = 1, width = 3
) {
  lineType <- match.arg(lineType, c("curved", "straight"))
  geojson <- NULL
  data    <- NULL
  if(is.character(coordinates)) {
    geojson <- paste0(suppressWarnings(readLines(coordinates)), collapse = "\n")
  } else {
    if(is.matrix(coordinates) || is.data.frame(coordinates)) {
      coordinates <- list(coordinates)
    }
    data <- lapply(coordinates, function(M) {
      if(is.data.frame(M)) {
        M <- as.matrix(M[, c("longitude", "latitude")])
      }
      list(
        geometry = list(
          "type"        = "LineString",
          "coordinates" = unname(M)
        )
      )
    })
  }
  series <- map[["x"]][["series"]] %||% list()
  series[[length(series) + 1L]] <- list(
    "type"    = "MapLineSeries",
    "data"    = data,
    "geojson" = geojson,
    "options" = list("lineType" = lineType),
    "style"   =  list(
      "stroke"        = validateColor(color),
      "strokeWidth"   = width,
      "strokeOpacity" = opacity
    )
  )
  map[["x"]][["series"]] <- series
  map
}

#' Add a line with a plane to a map
#' @description Add a line with a plane on it to an \code{amMapChart}.
#'
#' @param map an \code{amMapChart} widget
#' @param coordinates coordinates for a single line, a numeric matrix with
#'   two columns or a dataframe having two columns \code{longitude} and
#'   \code{latitude}
#' @param planePosition relative position of the plane on the line
#'   (0: beginning, 1: end)
#' @param lineType,color,opacity,width see \code{\link{addLines}}
#'
#' @return An \code{amMapChart} widget.
#' @export
#'
#' @examples
#' library(amMapCharts5)
#' continents <-
#'   system.file("geojson", "continentsLow.json", package = "amMapCharts5")
#' line <- rbind(
#'   c(-73.778137, 40.641312),
#'   c(-0.454296, 51.470020),
#'   c(116.597504, 40.072498)
#' )
#' amMapChart(projection = "naturalEarth1") %>%
#'   addPolygons(continents, color = "red", strokeColor = "black") %>%
#'   addLineWithPlane(line, planePosition = 0.2, color = "lime", width = 2)
addLineWithPlane <- function(
    map, coordinates, planePosition = 0.5, lineType = "curved",
    color = "red", opacity = 1, width = 3
) {
  lineType <- match.arg(lineType, c("curved", "straight"))
  if(is.data.frame(coordinates)) {
    coordinates <- as.matrix(coordinates[, c("longitude", "latitude")])
  }
  dataItem <- list(
    geometry = list(
      "type"        = "LineString",
      "coordinates" = unname(coordinates)
    )
  )
  series <- map[["x"]][["series"]] %||% list()
  series[[length(series) + 1L]] <- list(
    "type"          = "lineWithPlane",
    "planePosition" = planePosition,
    "dataItem"      = dataItem,
    "options"       = list("lineType" = lineType),
    "style"         =  list(
      "stroke"        = validateColor(color),
      "strokeWidth"   = width,
      "strokeOpacity" = opacity
    )
  )
  map[["x"]][["series"]] <- series
  map
}

#' Add clustered points to a map
#' @description Add some clustered points to an \code{amMapChart} (points close
#'   to each other are grouped).
#'
#' @param map an \code{amMapChart} widget
#' @param coordinates this can be a matrix with two columns, or a dataframe
#'    having two columns \code{longitude} and \code{latitude} and optionally
#'    a column \code{name} for the tooltips, or the path to a \strong{geojson}
#'    file
#' @param minDistance number of pixels; bullets closer than this distance
#'   between each other will be grouped
#' @param scatterDistance,scatterRadius,stopClusterZoom see
#'   \href{https://www.amcharts.com/docs/v5/charts/map-chart/clustered-point-series/#Scatter_settings}{Scatter settings}
#' @param bullet list of settings for the bullets created with
#'   \code{\link{amCircle}}, \code{\link{amTriangle}} or \code{\link{amRectangle}}
#' @param cluster list of settings for the clusters created with
#'   \code{\link{amCluster}}
#'
#' @return An \code{amMapChart} widget.
#' @export
#'
#' @examples
#' library(amMapCharts5)
#' continents <-
#'   system.file("geojson", "continentsLow.json", package = "amMapCharts5")
#' amMapChart() %>%
#'   addPolygons(continents, color = "violet", strokeColor = "black") %>%
#'   addClusteredPoints(
#'     cities,
#'     bullet = amTriangle("red", strokeColor = "black"),
#'     cluster = amCluster("orange")
#'   )
addClusteredPoints <- function(
    map, coordinates, minDistance = 20,
    scatterDistance = 10, scatterRadius = 10, stopClusterZoom = 0.95,
    bullet = amCircle("black"), cluster = amCluster("orange")
) {
  geojson <- NULL
  data    <- NULL
  if(is.character(coordinates)) {
    geojson <- paste0(suppressWarnings(readLines(coordinates)), collapse = "\n")
  } else {
    if(is.matrix(coordinates)) {
      colnames(coordinates) <- c("longitude", "latitude")
      coordinates <- as.data.frame(coordinates)
    }
    if(!is.element("name", colnames(coordinates))) {
      coordinates[["name"]] <- NA
    } else {
      bullet[["options"]][["tooltipY"]]    <- 0L
      bullet[["options"]][["tooltipText"]] <- "{name}"
    }
    coordinates <- unname(split(coordinates, 1L:nrow(coordinates)))
    data <- lapply(coordinates, function(row) {
      list(
        geometry = list(
          "type"        = "Point",
          "coordinates" = as.numeric(row[, c("longitude", "latitude")])
        ),
        name = row[["name"]]
      )
    })
  }
  series <- map[["x"]][["series"]] %||% list()
  series[[length(series) + 1L]] <- list(
    "type"    = "ClusteredPointSeries",
    "data"    = data,
    "geojson" = geojson,
    "options" = list(
      "minDistance"     = minDistance,
      "scatterDistance" = scatterDistance,
      "scatterRadius"   = scatterRadius,
      "stopClusterZoom" = stopClusterZoom
    ),
    "bullet"  = bullet,
    "cluster" = cluster
  )
  map[["x"]][["series"]] <- series
  map
}
