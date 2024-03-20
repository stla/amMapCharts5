#' Title
#'
#' @param map
#' @param coordinates
#' @param fill
#' @param stroke
#' @param strokeWidth
#' @param fillOpacity
#'
#' @return
#' @export
#'
#' @examples
addPolygons <- function(
    map, coordinates,
    fill = "red", stroke = "black", strokeWidth = 2, fillOpacity = 0
) {
  geojson <- NULL
  if(is.character(coordinates)) {
    geojson <- paste0(readLines(coordinates), collapse = "\n")
  }
  data <- NULL
  if(is.matrix(coordinates)) {
    coordinates <- list(coordinates)
  }
  if(is.list(coordinates)) {
    data <- lapply(coordinates, function(M) {
      list(
        geometry = list(
          "type" = "Polygon",
          "coordinates" = array(M, dim = c(1L, nrow(M), 2L))
        )
      )
    })
  }
  series <- map$x$series
  if(is.null(series)) {
    series <- list()
  }
  n <- length(series)
  series[[n+1L]] <- list(
    "type" = "MapPolygonSeries",
    "data" = data,
    "geojson" = geojson,
    "options" =  list(
      fill        = fill,
      stroke      = stroke,
      strokeWidth = strokeWidth,
      fillOpacity = fillOpacity
    )
  )
  map$x$series <- series
  map
}
