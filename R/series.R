#' Title
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
    "options" =  list(
      fill        = validateColor(color),
      stroke      = validateColor(strokeColor),
      strokeWidth = strokeWidth,
      fillOpacity = opacity
    )
  )
  map[["x"]][["series"]] <- series
  map
}

#' Title
#'
#' @param map
#' @param coordinates
#' @param bullet
#'
#' @return
#' @export
#'
#' @examples
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
    "bullet"  = bullet
  )
  map[["x"]][["series"]] <- series
  map
}
