library(amMapCharts5)

continents <-
  system.file("geojson", "continentsLow.json", package = "amMapCharts5")
dat <- cities

line <- rbind(
  c(-73.778137, 40.641312),
  c(-0.454296, 51.470020),
  c(116.597504, 40.072498)
)

amMapChart() |>
  addPolygons(gj, color = "orange", strokeColor = "black") |>
  addPoints(dat[1:2,], amCircle(color = "black", radius = 3)) |>
  addPoints(dat[3:4,], amCircle(color = "green", radius = 3)) %>%
  addLines(line, color = "purple", width = 3)



