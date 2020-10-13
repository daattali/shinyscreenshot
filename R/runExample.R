#' Run shinyscreenshot example
#'
#' Launch an example Shiny app that shows how easy it is to take screenshots
#' with `shinyscreenshot`.\cr\cr
#' The demo app is also
#' \href{https://daattali.com/shiny/shinyscreenshot-demo/}{available online}
#' to experiment with.
#' @export
runExample <- function() {
  appDir <- system.file("examples", "demo", package = "shinyscreenshot")
  shiny::runApp(appDir, display.mode = "normal")
}
