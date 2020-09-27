#' @export
screenshot <- function(selector = "body", filename = "shinyscreenshot", id = "",
                       scale = 1, timer = 0) {
  params <- getParams(as.list(environment()), server = TRUE)

  shiny::insertUI("head", "beforeEnd", getDependencies(), immediate = TRUE)

  session <- getSession()
  session$sendCustomMessage("screenshot", params)
}

#' @export
screenshotButton <- function(label = "Screenshot", icon = shiny::icon("camera"),
                             selector = "body", filename = "shinyscreenshot", id = "",
                             scale = 1, timer = 0) {
  params <- getParams(as.list(environment()), server = FALSE)

  btnid <- paste0("__shinyscreenshot-", gsub("-", "", uuid::UUIDgenerate()))

  tagList(
    getDependencies(),

    shiny::actionButton(
      inputId = btnid,
      label = label,
      icon = icon,
      `data-shinyscreenshot-params` = jsonlite::toJSON(params, auto_unbox = TRUE),
      onclick = paste0("shinyscreenshot.screenshotButton('", btnid, "')")
    )
  )
}
