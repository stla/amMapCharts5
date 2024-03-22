library(amMapCharts5)

continents <-
  system.file("geojson", "continentsLow.json", package = "amMapCharts5")

amMapChart() |>
  addPolygons(continents, color = "orange", strokeColor = "black") |>
  addClusteredPoints(cities, bullet = amCircle())

