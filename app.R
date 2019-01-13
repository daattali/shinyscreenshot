# inspired by Eric https://community.rstudio.com/t/taking-screenshots-within-a-shiny-app/6892
# (this is the second package that I make for the general public just because Eric asked a question that interested me and included a good resource)
# https://html2canvas.hertzen.com
# Limitations: browser support see, some CSS properties (which I think is the reason why leaflet shows up as just gray), more info at https://html2canvas.hertzen.com/documentation
# Also, images that have a large size (I haven't tested, but it seems when the canvas blobk is over 1 or 2 GB for me) it fails due to memory issues.
# also, due to bugs and limitations in html2canvas, some pages won't take a screenshot at all.

# bug with html2canvas: shiny sliders uses background: linear-gradient(to bottom, #DDD -50%, #FFF 150%)
# and it looks like having values below 0 or above 100 result in a fatal error.
# It's legal to do so (https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Images/Using_CSS_gradients#Positioning_color_stops)
# but regardless, it would be better if any errors encountered while converting to a canvas
# would not be fatal

library(shiny)

ui <- fluidPage(
  textInput("text", "Selector to capture", "#plot"),
  textInput("name", "name", "image.png"),
  actionButton("screenshot", "Screenshot"),
  numericInput("num", "Number", 10),
  numericInput("scale", "Scale", 1),
  plotOutput("plot"),
  plotly::plotlyOutput("plotly")
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    plot(seq(input$num))
  })

  output$plotly <- plotly::renderPlotly({
    plotly::plot_ly(iris, x = ~Sepal.Width, y = ~Sepal.Length)
  })

  observeEvent(input$screenshot, {
    screenshot(selector = input$text, filename = input$name, scale = input$scale)
  })
}

shinyApp(ui, server)
