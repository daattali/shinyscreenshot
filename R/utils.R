getSession <- function() {
  session <- shiny::getDefaultReactiveDomain()

  if (is.null(session)) {
    stop("Could not find a Shiny session.")
  }

  session
}

getDependencies <- function() {
  list(
    htmltools::htmlDependency(
      name = "html2canvas-js",
      version = "1.0.0",
      package = "shinyscreenshot",
      src = "assets/lib/html2canvas",
      script = "html2canvas.min.js"
    ),
    htmltools::htmlDependency(
      name = "filesaver-js",
      version = "1.0.0",
      package = "shinyscreenshot",
      src = "assets/lib/FileSaver",
      script = "FileSaver.js"
    ),
    htmltools::htmlDependency(
      name = "shinyscreenshot-binding",
      version = as.character(utils::packageVersion("shinyscreenshot")),
      package = "shinyscreenshot",
      src = "assets/shinyscreenshot",
      script = "shinyscreenshot.js"
    )
  )
}

getParams <- function(params, server = TRUE) {
  if (params[["timer"]] < 0) {
    stop("'timer' must be >= 0.", call. = FALSE)
  }
  if (params[["scale"]] <= 0) {
    stop("'scale' must be > 0.", call. = FALSE)
  }
  if (!params[["download"]] && is.null(params[["server_dir"]])) {
    stop("You must either set 'download=TRUE' or provide a 'server_dir'.", call. = FALSE)
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
    timer = params[["timer"]],
    download = params[["download"]],
    server_dir = params[["server_dir"]]
  )
}
