#' Add polygons to a map
#' @description Add some polygons to an \code{amMapChart}.
#'
#' @param map an \code{amMapChart} widget
#' @param coordinates for a single polygon, this can be a numeric matrix with
#'   two columns or a dataframe having two columns \code{longitude} and
#'   \code{latitude}; for multiple polygons, a list of such matrices or
#'   dataframes; or the path to a \strong{geojson} file
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
#' continents <-
#'   system.file("geojson", "continentsLow.json", package = "amMapCharts5")
#' amMapChart() %>%
#'   addPolygons(continents, color = "orange", strokeColor = "black")
addPolygons <- function(
    map, coordinates,
    color = NULL, opacity = NULL, strokeColor = NULL, strokeWidth = NULL
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
  series <- map[["x"]][["series"]]
  if(is.null(series)) {
    series <- list()
  }
  n <- length(series)
  series[[n+1L]] <- list(
    "type"    = "MapPolygonSeries",
    "data"    = data,
    "geojson" = geojson,
    "options" = emptyNamedList,
    "style"   =  list(
      fill        = validateColor(color),
      stroke      = validateColor(strokeColor),
      strokeWidth = strokeWidth,
      fillOpacity = opacity
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
#'    a column \code{title} for the tooltips, or the path to a \strong{geojson}
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
    map, coordinates, bullet
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
    if(!is.element("title", colnames(coordinates))) {
      coordinates[["title"]] <- NA
    } else {
      bullet[["options"]][["tooltipY"]]    <- 0L
      bullet[["options"]][["tooltipText"]] <- "{title}"
    }
    coordinates <- unname(split(coordinates, 1L:nrow(coordinates)))
    data <- lapply(coordinates, function(row) {
      list(
        geometry = list(
          "type"        = "Point",
          "coordinates" = as.numeric(row[, c("longitude", "latitude")])
        ),
        title = row[["title"]]
      )
    })
  }
  series <- map[["x"]][["series"]]
  if(is.null(series)) {
    series <- list()
  }
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

#' Add polygons to a map
#' @description Add some polygons to an \code{amMapChart}.
#'
#' @param map an \code{amMapChart} widget
#' @param coordinates for a single polygon, this can be a numeric matrix with
#'   two columns or a dataframe having two columns \code{longitude} and
#'   \code{latitude}; for multiple polygons, a list of such matrices or
#'   dataframes; or the path to a \strong{geojson} file
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
#' continents <-
#'   system.file("geojson", "continentsLow.json", package = "amMapCharts5")
#' amMapChart() %>%
#'   addPolygons(continents, color = "orange", strokeColor = "black")
addLines <- function(
    map, coordinates, lineType = "curved",
    color = NULL, opacity = NULL, width = NULL
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
          "type"        = "LineString",
          "coordinates" = unname(M)
        )
      )
    })
  }
  series <- map[["x"]][["series"]]
  if(is.null(series)) {
    series <- list()
  }
  series[[length(series) + 1L]] <- list(
    "type"    = "MapLineSeries",
    "data"    = data,
    "geojson" = geojson,
    "options" = list("lineType" = lineType),
    "style"   =  list(
      stroke        = validateColor(color),
      strokeWidth   = width,
      strokeOpacity = opacity
    )
  )
  map[["x"]][["series"]] <- series
  map
}
