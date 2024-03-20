library(amMapCharts5)

gj <- system.file("geojson", "continentsLow.json", package = "amMapCharts5")
amMapChart() |> addPolygons(gj, stroke = NULL)


