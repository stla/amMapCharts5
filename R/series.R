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
  if(!is.list(coordinates)) {
    coordinates <- list(coordinates)
  }
  series <- map$x$series
  if(is.null(series)) {
    series <- list()
  }
  n <- length(series)
  series[[n+1L]] <- list(
    "type" = "MapPolygonSeries",
    "data" = lapply(coordinates, function(M) {
      list(
        geometry = list(
          "type" = "Polygon",
          "coordinates" = array(M, dim = c(1L, nrow(M), 2L))
        )
      )
    }),
    "options" =  list(
      fill = fill,
      stroke = stroke,
      strokeWidth = strokeWidth,
      fillOpacity = fillOpacity
    )
  )
  map$x$series <- series
  map
}
