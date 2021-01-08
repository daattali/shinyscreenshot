.onLoad <- function(libname, pkgname) {
  shiny::registerInputHandler("shinyscreenshot", function(data, ...) {
    imgdata <- strsplit(data$image, ",")[[1]][2]

    if (!dir.exists(data$dir)) {
      warning("shinyscreenshot: server_dir path does not exist", call. = FALSE)
      return("")
    }
    if (file.access(data$dir, 2) == -1) {
      warning("shinyscreenshot: server_dir path is not writeable", call. = FALSE)
      return("")
    }

    retval <- tryCatch({
      filepath <- file.path(data$dir, data$filename)
      imgfile <- file(filepath, "wb")
      on.exit(close(imgfile))
      base64enc::base64decode(what = imgdata, output = imgfile)
      normalizePath(filepath)
    }, error = function(err) {
      warning("shinyscreenshot: image could not be saved to server", call. = FALSE)
      ""
    })

    retval
  }, force = TRUE)
}

.onUnload <- function(libpath) {
  shiny::removeInputHandler("shinyscreenshot")
}
