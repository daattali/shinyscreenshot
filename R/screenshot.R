#' @export
screenshot <- function(selector = "body", filename = "shinyscreenshot", id = "",
                       scale = 1, timer = 0) {
  if (timer < 0) {
    stop("'timer' must be >= 0.", call. = FALSE)
  }

  useShinyscreenshot()

  session <- getSession()

  if (nzchar(id)) {
    selector <- paste0("#",  session$ns(id))
  }

  params <- list(
    selector = selector,
    filename = paste0(filename, ".png"),
    scale = scale,
    timer = timer
  )
  session$sendCustomMessage("screenshot", params)
}
