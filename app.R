# https://html2canvas.hertzen.com
# Limitations: browser support see, some CSS properties (which I think is the reason why leaflet shows up as just gray), more info at https://html2canvas.hertzen.com/documentation
# Also, images that have a large size (I haven't tested, but it seems when the canvas blobk is over 1 or 2 GB for me) it fails due to memory issues.

library(shiny)

source("capture.R")

ui <- fluidPage(
  textInput("text", "Selector to capture", "#plot"),
  textInput("name", "name", "image.png"),
  actionButton("screenshot", "Screenshot"),
  plotOutput("plot"),
  plotly::plotlyOutput("plotly"),
  numericInput("num", "Number", 10)
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    plot(seq(input$num))
  })

  output$plotly <- plotly::renderPlotly({
    plotly::plot_ly(iris, x = ~Sepal.Width, y = ~Sepal.Length)
  })

  observeEvent(input$screenshot, {
    docapture(selector = input$text, filename = input$name)
  })
}

shinyApp(ui, server)
