library(amMapCharts5)

gj <- system.file("geojson", "continentsLow.json", package = "amMapCharts5")
dat <- cities

amMapChart() |>
  addPolygons(gj, stroke = NULL, fill = "orange") |>
  addPoints(dat[1:2,], amCircle(color = "black", radius = 3)) |>
  addPoints(dat[3:4,], amCircle(color = "green", radius = 3))



