#' @export
screenshot <- function(id = "", selector = "body", filename = "screenshot",
                       scale = 1, timer = 0) {
  if (timer < 0) {
    stop("'timer' must be >= 0.", call. = FALSE)
  }
  useShinyscreenshot()

  if (nzchar(id)) {
    selector <- paste0("#", id)
  }

  filename <- paste0(filename, ".png")

  session <- getSession()
  params <- list(
    selector = selector,
    filename = filename,
    scale = scale,
    timer = timer
  )
  session$sendCustomMessage("screenshot", params)
}
