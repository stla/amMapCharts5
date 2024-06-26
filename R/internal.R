regex_255 <- "\\s*([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\\s*"

regex_rgb <- paste0("^rgb\\(",
                    "(", regex_255, "),",
                    "(", regex_255, "),",
                    "(", regex_255, ")\\)$")

regex_360 <- "\\s*([012]?[0-9]?[0-9]|3[0-5][0-9]|360)\\s*"

regex_hsl <- paste0("^hsl\\(",
                    "(", regex_360, "),",
                    "(", regex_255, "),",
                    "(", regex_255, ")\\)$")

cssColors <- c("aqua", "crimson", "fuchsia", "indigo", "lime",
               "olive", "rebeccapurple", "silver", "teal")

#' @importFrom grDevices col2rgb rgb
#' @importFrom utils read.csv
#' @noRd
validateColor <- function(color){
  if(is.null(color)) return(NULL)
  if(grepl(regex_rgb, color) || grepl(regex_hsl, color)){
    return(color)
  }
  if(color %in% cssColors) {
    colorTable <- read.csv(
      system.file("cssColors", "cssColors.csv", package = "amMapCharts5")
    )
    i <- which(colorTable[["color"]] == tolower(color))
    return(colorTable[["hex"]][i])
  }
  RGB <- col2rgb(color)[,1]
  rgb(RGB["red"], RGB["green"], RGB["blue"], maxColorValue = 255)
}

`%||%` <- function(x, y){
  if(is.null(x)) y else x
}

isPositiveInteger <- function(x){
  is.numeric(x) && (length(x) == 1L) && (!is.na(x)) && (floor(x) == x)
}

isNumber <- function(x){
  is.numeric(x) && (length(x) == 1L) && (!is.na(x))
}

emptyNamedList <- `names<-`(list(), character(0L))
