.onLoad <- function(libname, pkgname) {
  shiny::registerInputHandler("shinyscreenshot", function(data, ...) {
    imgdata <- strsplit(data$image, ",")[[1]][2]

    if (!dir.exists(data$dir)) {
      warning("shinyscreenshot: server_dir path does not exist", call. = FALSE)
      return(FALSE)
    }
    if (file.access(data$dir, 2) == -1) {
      warning("shinyscreenshot: server_dir path is not writeable", call. = FALSE)
      return(FALSE)
    }

    success <- tryCatch({
      imgfile <- file(file.path(data$dir, data$filename), "wb")
      on.exit(close(imgfile))
      base64enc::base64decode(what = imgdata, output = imgfile)
      TRUE
    }, error = function(err) {
      warning("shinyscreenshot: image could not be saved to server", call. = FALSE)
      FALSE
    })

    success
  }, force = TRUE)
}

.onUnload <- function(libpath) {
  shiny::removeInputHandler("shinyscreenshot")
}
