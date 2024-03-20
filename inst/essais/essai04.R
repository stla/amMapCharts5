library(amMapCharts5)

gj <- system.file("geojson", "continentsLow.json", package = "amMapCharts5")
dat <- unname(as.matrix(cities[, c("latitude", "longitude")]))

amMapChart() |>
  addPolygons(gj, stroke = NULL, fill = "transparent") |>
  addPoints(dat[1:2,], amCircle(color = "black", opacity = 0.5)) |>
  addPoints(dat[3:4,], amCircle(color = "black", opacity = 0.5))



