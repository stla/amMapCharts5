library(amMapCharts5)
library(shiny)

world <-
  system.file("geojson", "worldLow.json", package = "amMapCharts5")
line <- rbind(
  c(-73.778137, 40.641312),
  c(-0.454296, 51.470020),
  c(116.597504, 40.072498)
)
map <- amMapChart(projection = "Mercator") %>%
  addPolygons(world, color = "red", strokeColor = "black") %>%
  addLineWithPlane(line, planePosition = 0.2, color = "lime", width = 2)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      radioButtons(
        "projection",
        label = "Projection",
        choices = c(
          "equalEarth",
          "equirectangular",
          "Mercator",
          "naturalEarth1",
          "orthographic"
        ),
        selected = "Mercator"
      )
    ),
    mainPanel(
      br(),
      amMapChartOutput("map")
    )
  )
)

server <- function(input, output, session) {

  output[["map"]] <- renderAmMapChart({
    map
  })

  observeEvent(input[["projection"]], {
    updateAmMapChart(session, "map", projection = input[["projection"]])
  }, ignoreInit = TRUE)

}

shinyApp(ui, server)
