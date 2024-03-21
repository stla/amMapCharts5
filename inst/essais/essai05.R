library(amMapCharts5)
world <-
  system.file("geojson", "worldLow.json", package = "amMapCharts5")
line <- rbind(
  c(-73.778137, 40.641312),
  c(-0.454296, 51.470020),
  c(116.597504, 40.072498)
)
amMapChart(projection = "naturalEarth1") %>%
  addPolygons(world, color = "red", strokeColor = "black") %>%
  addLineWithPlane(line, planePosition = 0.2, color = "lime", width = 2)



