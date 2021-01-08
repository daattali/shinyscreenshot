#' Capture a screenshot of a shiny app
#'
#' Screenshots can be either of the entire viewable page (default), or of a specific
#' section of the page. The captured image is automatically downloaded as a
#' PNG image.\cr\cr
#' This function gets called from the server portion of a Shiny app, unlike
#' [`screenshotButton()`] which is similar but gets called from the UI.
#'
#' @param selector CSS selector for the element that should be captured. If multiple
#' elements match the selector, only the first one is captured. Default is to capture
#' the entire page.
#' @param filename Name of the file to be saved. A PNG extension will automatically be added.
#' @param id As an alternative to `selector`, an ID of the element that should be captured
#' can be provided. If `id` is provided, then `selector` is ignored. When used in a module,
#' the `id` **does not** need to be namespaced (namespacing is automatic).
#' @param scale The scale of the image. Default is 1, which means the dimensions of the image
#' will be exactly the dimensions in the browser. For example, a value of 2 will result in an
#' image that's twice the height and width (and a larger file size).
#' @param timer Number of seconds to wait before taking the screenshot. Default is 0, which
#' takes a screenshot immediately.
#' @param download If `TRUE` (default), download the screenshot image to the user's computer.
#' If `FALSE`, the image isn't downloaded to the user, and a `server_dir` should be specified.
#' @param server_dir Directory on the server where the screenshot image should be saved. Note
#' that only the directory should be specified, not the file name. The directory must exist
#' and be writeable. If `NULL` (default), the screenshot image is only downloaded to the
#' user's computer and is not saved to the server. If a relative path is provided, it is relative
#' to the Shiny app's working directory. For example, `server_dir="."` will save the image in
#' the same directory that the Shiny app is in.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   library(shinyscreenshot)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       h1("{shinyscreenshot} demo"),
#'       numericInput("num", "Number of points", 50),
#'       plotOutput("plot"),
#'       actionButton("screenshot1", "Capture entire page"),
#'       actionButton("screenshot2", "Capture plot")
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$screenshot1, {
#'         screenshot()
#'       })
#'       observeEvent(input$screenshot2, {
#'         screenshot(id = "plot")
#'       })
#'       output$plot <- renderPlot({
#'         plot(runif(input$num))
#'       })
#'     }
#'   )
#' }
#' @export
screenshot <- function(selector = "body", filename = "shinyscreenshot", id = "",
                       scale = 1, timer = 0, download = TRUE, server_dir = NULL) {
  params <- getParams(as.list(environment()), server = TRUE)

  shiny::insertUI("head", "beforeEnd", getDependencies(), immediate = TRUE)

  session <- getSession()
  params$namespace <- session$ns("")
  session$sendCustomMessage("screenshot", params)
}

#' Button that captures a screenshot of a shiny app
#'
#' Create a button that, when clicked, captures a screenshot of the Shiny app.
#' Screenshots can be either of the entire viewable page (default), or of a specific
#' section of the page. The captured image is automatically downloaded as a
#' PNG image.\cr\cr
#' This function gets called from the UI portion of a Shiny app, unlike
#' [`screenshot()`] which is similar but gets called from the server.
#' @inheritParams screenshot
#' @param id As an alternative to `selector`, an ID of the element that should be captured
#' can be provided. If `id` is provided, then `selector` is ignored. When used in a module,
#' the `id` **does** need to be namespaced, like any other UI element.
#' @param ... Any other parameters that should be passed along to the [`shiny::actionButton()`].
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   library(shinyscreenshot)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       h1("{shinyscreenshot} demo"),
#'       screenshotButton(label = "Capture entire page"),
#'       screenshotButton(label = "Capture plot", id = "plot"), br(), br(),
#'       numericInput("num", "Number of points", 50),
#'       plotOutput("plot")
#'     ),
#'     server = function(input, output) {
#'       output$plot <- renderPlot({
#'         plot(runif(input$num))
#'       })
#'     }
#'   )
#' }
#' @export
screenshotButton <- function(selector = "body", filename = "shinyscreenshot", id = "",
                             scale = 1, timer = 0, download = TRUE, server_dir = NULL,
                             ns = NS(NULL), ...) {
  params <- getParams(as.list(environment()), server = FALSE)
  params$namespace <- ns("")

  btnParams <- eval(substitute(alist(...)))
  if (! "label" %in% names(btnParams)) {
    btnParams[["label"]] <- "Screenshot"
  }
  if (! "icon" %in% names(btnParams)) {
    btnParams[["icon"]] <- shiny::icon("camera")
  }

  btnid <- paste0("__shinyscreenshot-", gsub("-", "", uuid::UUIDgenerate()))
  btnParams[["inputId"]] <- btnid
  btnParams[["onclick"]] <- paste0("shinyscreenshot.screenshotButton('", btnid, "')")
  btnParams[["data-shinyscreenshot-params"]] <- jsonlite::toJSON(
    params, auto_unbox = TRUE, null = "null"
  )

  shiny::tagList(
    getDependencies(),
    do.call(shiny::actionButton, btnParams)
  )
}
