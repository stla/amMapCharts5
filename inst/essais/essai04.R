library(amMapCharts5)

continents <-
  system.file("geojson", "continentsLow.json", package = "amMapCharts5")
dat <- cities

amMapChart() |>
  addPolygons(gj, color = "orange", strokeColor = "black") |>
  addPoints(dat[1:2,], amCircle(color = "black", radius = 3)) |>
  addPoints(dat[3:4,], amCircle(color = "green", radius = 3))



