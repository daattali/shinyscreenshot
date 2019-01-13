#' @export
screenshot <- function(id = "", selector = "body", filename = "screenshot.png",
                       scale = 1) {
  useShinyscreenshot()

  if (nzchar(id)) {
    selector <- paste0("#", id)
  }

  session <- getSession()
  session$sendCustomMessage("screenshot", list(selector = selector, filename = filename, scale = scale))
}



useShinyscreenshot <- function() {
  session <- getSession()

  # Make sure shinyscreenshot resources are only added to the page once
  if (!is.null(attr(session, "shinyscreenshot_attached"))) {
    return()
  }
  attr(session, "shinyscreenshot_attached") <- TRUE

  shiny::addResourcePath("resources",
                         system.file("www", package = "shinyscreenshot"))

  shiny::insertUI("head", "beforeEnd", {
    shiny::singleton(shiny::tags$head(
      shiny::tags$script(src = "resources/shared/html2canvas/html2canvas.min.js"),
      shiny::tags$script(src = "resources/srcjs/shinyscreenshot.js"),
      #shiny::tags$script(src = "resources/srcjs/saveFile.js") # this is v1
      shiny::tags$script(src = "resources/shared/FileSaver/FileSaver.js") # this is version2, works on large blobs (like when you scale or if the image has a lot of details)
    ))
  }, immediate = TRUE)
}
