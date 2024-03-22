#' Bullets
#' @description Create a list of settings for bullets,
#'   their shape and their style.
#'
#' @param color bullet color
#' @param opacity bullet opacity, a number between 0 and 1
#' @param width bullet width
#' @param height bullet height
#' @param radius circle radius
#' @param strokeColor stroke color of the bullet
#' @param strokeOpacity stroke opacity of the bullet, a number between 0 and 1
#' @param strokeWidth stroke width of the bullet
#' @param rotation rotation angle
#' @param cornerRadius radius of the rectangle corners
#'
#' @note A color can be given by the name of a R color, the name of a CSS
#'   color, e.g. \code{"transparent"} or \code{"fuchsia"}, an HEX code like
#'   \code{"#ff009a"}, a RGB code like \code{"rgb(255,100,39)"}, or a HSL code
#'   like \code{"hsl(360,11,255)"}.
#'
#' @return A list of settings for the bullets.
#' @export
#'
#' @name amMapCharts5-shapes
amTriangle <- function(
    color = NULL,
    opacity = 1,
    width = 10,
    height = 10,
    strokeColor = NULL,
    strokeOpacity = 1,
    strokeWidth = 2,
    rotation = 0
){
  bullet <- list(
    shape = "Triangle",
    options = list(
      fill = validateColor(color),
      fillOpacity = opacity,
      width = width,
      height = height,
      stroke = validateColor(strokeColor),
      strokeOpacity = strokeOpacity,
      strokeWidth = strokeWidth,
      rotation = rotation
    )
  )
  class(bullet) <- "bullet"
  bullet
}

#' @rdname amMapCharts5-shapes
#' @export
amCircle <- function(
    color = NULL,
    opacity = 1,
    radius = 4,
    strokeColor = NULL,
    strokeOpacity = 1,
    strokeWidth = 2
){
  bullet <- list(
    shape = "Circle",
    options = list(
      fill = validateColor(color),
      fillOpacity = opacity,
      radius = radius,
      stroke = validateColor(strokeColor),
      strokeOpacity = strokeOpacity,
      strokeWidth = strokeWidth
    )
  )
  class(bullet) <- "bullet"
  bullet
}

#' @rdname amMapCharts5-shapes
#' @export
amRectangle <- function(
    color = NULL,
    opacity = 1,
    width = 10,
    height = 10,
    strokeColor = NULL,
    strokeOpacity = 1,
    strokeWidth = 2,
    rotation = 0,
    cornerRadius = 3
){
  bullet <- list(
    shape = "Rectangle",
    options = list(
      fill = validateColor(color),
      fillOpacity = opacity,
      width = width,
      height = height,
      stroke = validateColor(strokeColor),
      strokeOpacity = strokeOpacity,
      strokeWidth = strokeWidth,
      rotation = rotation,
      cornerRadius = cornerRadius
    )
  )
  class(bullet) <- "bullet"
  bullet
}

#' Cluster settings
#' @description Settings of clusters for usage in
#'   \code{\link{addClusteredPoints}}.
#'
#' @param color color
#' @param radius radius
#' @param labelColor label color
#' @param fontSize label font size
#'
#' @return A list of settings for the clusters.
#' @export
amCluster <- function(
    color = NULL,
    radius = 6,
    labelColor = "black",
    fontSize = 8
){
  cluster <- list(
    color = validateColor(color),
    radius = radius,
    labelColor = labelColor,
    fontSize = fontSize
  )
  class(cluster) <- "cluster"
  cluster
}
