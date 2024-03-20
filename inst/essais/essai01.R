library(amMapCharts5)
library(geojsonR)

gj <- system.file("geojson", "Lithuania.geojson", package = "amMapCharts5")
#dat <- FROM_GeoJson(gj)
dat <- jsonlite::fromJSON(gj)
amMapChart(dat)


