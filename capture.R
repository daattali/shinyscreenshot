
docapture <- function(id = "", selector = "body", filename = "screenshot.png", scale = 1) {
  setupcapture()

  if (nzchar(id)) {
    selector <- paste0("#", id)
  }

  session <- getSession()
  session$sendCustomMessage("screenshot", list(selector = selector, filename = filename, scale = scale))
}

getSession <- function() {
  session <- shiny::getDefaultReactiveDomain()

  if (is.null(session)) {
    stop("Could not find a Shiny session.")
  }

  session
}

setupcapture <- function() {
  session <- getSession()

  if (!is.null(attr(session, "shinyshot_attached"))) {
    return()
  }
  attr(session, "shinyshot_attached") <- TRUE

  shiny::addResourcePath("shinyscreenshot", "~/../R/shinyscreenshot/www/")

  shiny::insertUI("head", "beforeEnd", {
    shiny::singleton(shiny::tags$head(
      shiny::tags$script(src = "shinyscreenshot/saveFile.js"),
      shiny::tags$script(src = "shinyscreenshot/FileSaver.js"), # this is version2, use version 1 first but it doesn't work on large blobs (like when you scale or if the image has a lot of details)
      shiny::tags$script(src = "shinyscreenshot/html2canvas.min.js")
    ))
  }, immediate = TRUE)
}
