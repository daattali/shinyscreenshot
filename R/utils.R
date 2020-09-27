getSession <- function() {
  session <- shiny::getDefaultReactiveDomain()

  if (is.null(session)) {
    stop("Could not find a Shiny session.")
  }

  session
}

getDependencies <- function() {
  shiny::addResourcePath("shinyscreenshot-assets",
                         system.file("assets", package = "shinyscreenshot"))

  shiny::singleton(shiny::tags$head(
    shiny::tags$script(src = "shinyscreenshot-assets/js/html2canvas/html2canvas.min.js"),
    shiny::tags$script(src = "shinyscreenshot-assets/js/FileSaver/FileSaver.js"),
    shiny::tags$script(src = "shinyscreenshot-assets/js/shinyscreenshot/shinyscreenshot.js")
  ))
}

getParams <- function(params, server = TRUE) {
  if (params[["timer"]] < 0) {
    stop("'timer' must be >= 0.", call. = FALSE)
  }

  if (nzchar(params[["id"]])) {
    if (server) {
      session <- getSession()
      params[["selector"]] <- paste0("#", session$ns(params[["id"]]))
    } else {
      params[["selector"]] <- paste0("#", params[["id"]])
    }
  }
  params[["filename"]] <- paste0(params[["filename"]], ".png")

  list(
    selector = params[["selector"]],
    filename = params[["filename"]],
    scale = params[["scale"]],
    timer = params[["timer"]]
  )
}
