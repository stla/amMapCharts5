library(amMapCharts5)
continents <-
  system.file("geojson", "continentsLow.json", package = "amMapCharts5")
amMapChart() |>
  addPolygons(continents, color = "violet", strokeColor = "black") |>
  addClusteredPoints(
    cities,
    bullet = amTriangle("red", strokeColor = "black"),
    cluster = amCluster("orange")
  )

