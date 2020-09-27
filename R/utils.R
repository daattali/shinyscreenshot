getSession <- function() {
  session <- shiny::getDefaultReactiveDomain()

  if (is.null(session)) {
    stop("Could not find a Shiny session.")
  }

  session
}

useShinyscreenshot <- function() {
  session <- getSession()

  if (!is.null(attr(session, "shinyscreenshot_attached"))) {
    return()
  }
  attr(session, "shinyscreenshot_attached") <- TRUE

  shiny::addResourcePath("shinyscreenshot-assets",
                         system.file("assets", package = "shinyscreenshot"))

  shiny::insertUI("head", "beforeEnd", {
    shiny::singleton(shiny::tags$head(
      shiny::tags$script(src = "shinyscreenshot-assets/js/html2canvas/html2canvas.min.js"),
      shiny::tags$script(src = "shinyscreenshot-assets/js/FileSaver/FileSaver.js"),
      shiny::tags$script(src = "shinyscreenshot-assets/js/shinyscreenshot/shinyscreenshot.js")
    ))
  }, immediate = TRUE)
}
