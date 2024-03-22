library(amMapCharts5)
library(shiny)

world <-
  system.file("geojson", "worldLow.json", package = "amMapCharts5")
map <- amMapChart("Mercator", panX = "translateX", panY = "translateY") %>%
  addPolygons(world, color = "violet", strokeColor = "black") %>%
  addClusteredPoints(
    cities,
    bullet = amTriangle("red", strokeColor = "black"),
    cluster = amCluster("orange")
  )

ui <- fluidPage(
  br(), br(), br(),
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
      ),
      radioButtons(
        "panX",
        label = "Horizontal dragging (panX)",
        choices = c(
          "translateX",
          "rotateX"
        ),
        selected = "translateX"
      ),
      radioButtons(
        "panY",
        label = "Vertical dragging (panY)",
        choices = c(
          "translateY",
          "rotateY"
        ),
        selected = "translateY"
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

  observeEvent(input[["panX"]], {
    updateAmMapChart(session, "map", panX = input[["panX"]])
  }, ignoreInit = TRUE)

  observeEvent(input[["panY"]], {
    updateAmMapChart(session, "map", panY = input[["panY"]])
  }, ignoreInit = TRUE)

}

shinyApp(ui, server)
