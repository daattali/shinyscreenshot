library(shiny)
library(shinyscreenshot)

share <- list(
  title = "{shinyscreenshot} package",
  url = "https://daattali.com/shiny/shinyscreenshot-demo/",
  source = "https://github.com/daattali/shinyscreenshot",
  image = "https://daattali.com/shiny/img/shinyscreenshot.png",
  description = "Capture screenshots of entire pages or parts of pages in Shiny apps",
  twitter_user = "daattali"
)

ui <- fluidPage(
  shinydisconnect::disconnectMessage2(),
  title = paste0("shinyscreenshot package ", as.character(packageVersion("shinyscreenshot"))),
  tags$head(
    includeCSS(file.path('www', 'style.css')),
    # Favicon
    tags$link(rel = "shortcut icon", type="image/x-icon", href="https://daattali.com/shiny/img/favicon.ico"),
    # Facebook OpenGraph tags
    tags$meta(property = "og:title", content = share$title),
    tags$meta(property = "og:type", content = "website"),
    tags$meta(property = "og:url", content = share$url),
    tags$meta(property = "og:image", content = share$image),
    tags$meta(property = "og:description", content = share$description),

    # Twitter summary cards
    tags$meta(name = "twitter:card", content = "summary"),
    tags$meta(name = "twitter:site", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:creator", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:title", content = share$title),
    tags$meta(name = "twitter:description", content = share$description),
    tags$meta(name = "twitter:image", content = share$image)
  ),

  div(id = "header",
      div(id = "pagetitle", share$title),
      div(id = "subtitle", share$description),
      div(id = "subsubtitle",
          "Created by",
          tags$a(href = "https://deanattali.com/", "Dean Attali"),
          HTML("&bull;"),
          "Available",
          tags$a(href = share$source, "on GitHub"),
          HTML("&bull;"),
          tags$a(href = "https://daattali.com/shiny/", "More apps"), "by Dean"
      )
  ),

  fluidRow(column(
    width = 6, offset = 3,
    div(
      id = "main-row",
      actionButton("action", "Take Screenshot", icon("camera"), class = "btn-success"),
      br(), br()
    )
  )),

  fluidRow(
    column(
      3,
      div(
        id = "inputs",
        selectInput("selector", "What to capture?",
                    c("Entire page" = "body", "Timeline" = "#timeline", "Inputs" = "#inputs")),
        sliderInput("scale", "Scale", min = 0.5, max = 3, value = 1, step = 0.5),
        textInput("filename", "File name", "screenshot")
      ),
      h3("Generated code"),
      verbatimTextOutput("code")
    ),
    column(
      9,
      h3("World Cup 2014: take a screenshot after interacting with the timeline"),
      timevis::timevisOutput("timeline"))
  )
)

server <- function(input, output, session) {
  output$timeline <- timevis::renderTimevis({

    countryToBase64Img <- list(
      "Argentina" = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAUBAMAAAAevyJ8AAAAJ1BMVEWiyOp0rN/////58+3fsGny38fnowzz5Nfr0Krr07ndqUvs1LXSnlC6gwhIAAAANklEQVQY02MQRAMMNBHAAEoQYBoMZUAFlFs8jFAE1N1yilAEVJelBKFq2eKJqgXJUAxAF98CAFcNHShSkYrsAAAAAElFTkSuQmCC",
      "Belgium" = "iVBORw0KGgoAAAANSUhEUgAAABcAAAAUBAMAAACUkLs9AAAAElBMVEUAAABVSgzvM0D0ajf1ajf92iXQKeqYAAAAHUlEQVQY02NgYGBgDA0NDVFSUlJggHKCRwwH7G0AncUk97jJjWYAAAAASUVORK5CYII=",
      "Brazil" = "iVBORw0KGgoAAAANSUhEUgAAAB0AAAAUCAMAAABGQsb1AAAAe1BMVEUAmzoEKnj52wIKL3lBrSsHnDjb1Qj+3wAAJ3akxxRetCQToDUopjBDWGHEzw3r2gQhRoYfPWcYoTSHvxv63gGyzcyGiDcqS4uMkTo2WJETN32+tTq2qyF+p67eyA82TV1baUzItxns0Qh+vB1+mLZqmKKeu8OSr71VcKRxCrRcAAAArElEQVQoz62Rxw6DMBBEsY2zQ7fpvaX+/xfmgFCAgFCkzPVJq7czhvGvSFseQ/NCF/OAORYREVnOHrSDsddM92NgfzHXp0EDAPRAvru2iWLiXpEJAOg48atc2RBVzb15JM8XUBN97MLJJs0AQN2SIl3azRSCQQBZkk80XF6uFQNjAlDV8vJs1TGFkrHC4xRHcvtRKwCIsmy3H01t8NwTXs532jhr8mSFswV/zBsgcAoSjHCdRAAAAABJRU5ErkJggg==",
      "Colombia" = "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAUAgMAAADnxWVXAAAACVBMVEUAMIfIEC7/zQBWZSB5AAAAF0lEQVQI12NYBQELGKjOIAmEQkAAMQwA+9NB7HYGMdMAAAAASUVORK5CYII=",
      "Costa Rica" = "iVBORw0KGgoAAAANSUhEUgAAACEAAAAUCAMAAAA0jaRDAAAAP1BMVEX////y28NtdFSWxM8AFIntmI/laWD2ycbaKRy/xOHp3d3t7ubYx6GrwaTdPDDofHV3eIPaKh0mdlbErIY3fWbk5bcpAAAAUklEQVQoz2NgIQQYqKGCkxBgoAZgJwQYOKCAlYuLnwMbgKlg4+bl5ebDp4KVh5mZkQ2vCiYRISa8KtiEBQR48NoiyMrIiMOlhH1LDUA45uiSggASiQ2ajzJk0wAAAABJRU5ErkJggg==",
      "France" = "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAUAgMAAADnxWVXAAAACVBMVEUAI5XtKTn///+i/AH+AAAAFElEQVQI12NgYOBatSo0NIBh6DAATSAu4Xxi9HsAAAAASUVORK5CYII=",
      "Germany" = "iVBORw0KGgoAAAANSUhEUgAAACEAAAAUBAMAAADxfUlCAAAAD1BMVEUAAABKAADdAAD0igD/zgDupiNjAAAAIUlEQVQY02NgoCMQRAMCDEpoQIGGIsZowIDBBQ040E4EAM/nLQEUDzk4AAAAAElFTkSuQmCC",
      "Netherlands" = "iVBORw0KGgoAAAANSUhEUgAAAB4AAAAUBAMAAABohZD3AAAAD1BMVEUhRotrhLKuHCjIZm7///9fvUPgAAAAHElEQVQY02NUYkABTAzU5bMI4udT2z5GNPNpDQBo2wB0uX4S5QAAAABJRU5ErkJggg=="
    )

    templateWC <- function(stage, team1, team2, score1, score2) {
      sprintf(
        '<table><tbody>
      <tr><td colspan="3"><em>%s</em></td></tr>
      <tr>
        <td>%s</td>
        <th>&nbsp;%s - %s&nbsp;</th>
        <td>%s</td>
      </tr>
      <tr>
        <td><img src="data:image/png;base64,%s" width="31" height="20" alt="%s"></td>
        <th></th>
        <td><img src="data:image/png;base64,%s" width="31" height="20" alt="%s"></td>
      </tr>
    </tbody></table>',
        stage, team1, score1, score2, team2, countryToBase64Img[[team1]], team1, countryToBase64Img[[team2]], team2
      )
    }

    # Data for world cup 2014
    dataWC <- data.frame(
      id = 1:7,
      start = c(
        "2014-07-04 13:00",
        "2014-07-04 17:00",
        "2014-07-05 13:00",
        "2014-07-05 17:00",
        "2014-07-08 17:00",
        "2014-07-09 17:00",
        "2014-07-13 16:00"
      ),
      content = c(
        templateWC("quarter-finals", "France", "Germany", 0, 1),
        templateWC("quarter-finals", "Brazil", "Colombia", 2, 1),
        templateWC("quarter-finals", "Argentina", "Belgium", 1, 0),
        templateWC("quarter-finals", "Netherlands", "Costa Rica", "0 (4)", "0 (3)"),
        templateWC("semi-finals", "Brazil", "Germany", 1, 7),
        templateWC("semi-finals", "Netherlands", "Argentina", "0 (2)", "0 (4)"),
        templateWC("final", "Germany", "Argentina", 1, 0)
      )
    )

    timevis::timevis(dataWC)
  })

  code <- reactive({
    if (input$selector == "body") {
      selector <- ""
    } else {
      selector <- paste0('  selector = "', input$selector, '",\n')
    }
    paste0(
      'screenshot(\n',
      selector,
      '  scale = ', input$scale, ',\n',
      '  filename = "', input$filename, '"\n',
      ')'
    )
  })

  observeEvent(input$action, {
    eval(parse(text = code()))
  })

  output$code <- renderText({
    paste0(
      "library(shiny)\nlibrary(shinyscreenshot)\n\n",
      "ui <- fluidPage(\n  # UI code\n)\n\n",
      "server <- function(input, output) {\n  # Take a screenshot\n  ",
      gsub("\n", "\n  ", code()),
      "\n}\n\nshinyApp(ui, server)"
    )
  })
}

shinyApp(ui, server)
