<p align="center">
  <h3 align="center">shinyscreenshot</h3>

  <h4 align="center">
    Capture screenshots of entire pages or parts of pages in Shiny apps
    <br><br>
    <a href="https://daattali.com/shiny/shinyscreenshot-demo/">Demo</a>
    &middot;
    by <a href="https://deanattali.com">Dean Attali</a>
    &middot;
    <a href="https://www.youtube.com/watch?v=fsd81mnxtNs">10-min Tutorial</a>
  </h4>

  <p align="center">
    <a href="https://travis-ci.org/daattali/shinyscreenshot">
      <img src="https://travis-ci.org/daattali/shinyscreenshot.svg?branch=master" alt="Build Status" />
    </a>
    <a href="https://cran.r-project.org/package=shinyscreenshot">
      <img src="https://www.r-pkg.org/badges/version/shinyscreenshot" alt="CRAN version" />
    </a>
  </p>

</p>

---

{shinyscreenshot} allows you to capture screenshots of entire pages or parts of pages in Shiny apps. Can be used to capture the *current* state of a Shiny app, including interactive widgets (such as plotly, timevis, maps, etc). The captured image is automatically downloaded as a PNG image.

**Need Shiny help? [I’m available for
consulting](https://attalitech.com/).**<br/> **If you find {shinyscreenshot}
useful, please consider [supporting my
work](https://github.com/sponsors/daattali) to unlock rewards\! ❤**

<p align="center">

<a style="display: inline-block;" href="https://github.com/sponsors/daattali">
<img height="35" src="https://i.imgur.com/034B8vq.png" /> </a>

<a style="display: inline-block;" href="https://paypal.me/daattali">
<img height="35" src="https://camo.githubusercontent.com/0e9e5cac101f7093336b4589c380ab5dcfdcbab0/68747470733a2f2f63646e2e6a7364656c6976722e6e65742f67682f74776f6c66736f6e2f70617970616c2d6769746875622d627574746f6e40312e302e302f646973742f627574746f6e2e737667" />
</a>

</p>

# Table of contents

  - [How to use](#usage)
  - [Screenshot button](#screenshotbutton)
  - [Features](#features)
  - [Installation](#install)
  - [Motivation](#motivation)
  - [Browser support and limitations](#limitations)
  - [Similar packages](#similar)
  - [Sponsors 🏆](#sponsors)

<h2 id="usage">How to use</h2>

Using {shinyscreenshot} is as easy as it gets. When you want to take a screenshot, simply call `screenshot()` and a full-page screenshot will be taken and downloaded as a PNG image. **[Try it for yourself](https://daattali.com/shiny/shinyscreenshot-demo/) or [watch a short tutorial](https://www.youtube.com/watch?v=fsd81mnxtNs)!**

It's so simple that an example isn't needed, but here's one anyway:

    library(shiny)
    library(shinyscreenshot)

    ui <- fluidPage(
      textInput("text", "Enter some text", "test"),
      actionButton("go", "Take a screenshot")
    )

    server <- function(input, output) {
      observeEvent(input$go, {
        screenshot()
      })
    }
    
    shinyApp(ui, server)

<h2 id="screenshotbutton">Screenshot button</h2>

The `screenshot()` function can be called any time inside the server portion of a Shiny app. A very common case is to take a screenshot after clicking a button. That case is so common that there's a function for it: `screenshotButton()`. It accepts all the same parameters as `screenshot()`, but instead of calling it in the server, you call it in the UI. 

`screenshotButton()` creates a button that, when clicked, will take a screenshot.

<h2 id="features">Features</h2>

- **Region:** By default, the entire page is captured. If you'd like to capture a specific part of the screen, you can use the `selector` parameter to specify a CSS selector. For example, if you have a plot with ID `myplot` then you can use `screenshot(selector="#myplot")`.

- **Scale:** The image file will have the same height and width as what is visible in the browser. Using `screenshot(scale=2)` will result in an image that's twice the height and width (and also a larger file size).

- **Timer:** Usually you want the screenshot to be taken immediately, but sometimes you may want to tell Shiny to take a screenshot in, for example, 3 seconds from now. That can be done using `screenshot(timer=3)`.

- **File name:** You can choose the name of the downloaded file using the `filename` parameter.

- **Module support:** As an alternative to the `selector` argument, you can also use the `id` argument. For example, instead of using `screenshot(selector="#myplot")`, you could use `screenshot(id="myplot")`. The advantage with using an ID directly is that the `id` parameter is module-aware, so even if you're taking a screenshot inside a Shiny module, you don't need to worry about namespacing.

<h2 id="install">Installation</h2>

To install the stable CRAN version:

    install.packages("shinyscreenshot")

To install the latest development version from GitHub:

    install.packages("remotes")
    remotes::install_github("daattali/shinyscreenshot")

<h2 id="motivation">Motivation</h2>

For years, I saw people asking online how can they take screenshots of the current state of a Shiny app. This question comes up especially with interactive outputs (plotly, timevis, maps, DT, etc). Some of these don't allow any way to save the current state as an image, and a few do have a "Save as image" option, but they only save the base/initial state of the output, rather than the current state after receiving user interaction.

After seeing many people asking about this, one day my R-friend Eric Nantz [asked about it as well](https://community.rstudio.com/t/taking-screenshots-within-a-shiny-app/6892), which gave me the motivation to come up with a solution.

<h2 id="limitations">Browser support and limitations</h2>

The screenshots are powered by the 'html2canvas' JavaScript library. They do not always produce perfect screenshots, please refer to 'html2canvas' for more information about the limitations.

The JavaScript libraries used in this package may not be supported by all browsers. {shinyscreenshot} should work on Chrome, Firefox, Edge, Chrome on Android, Safari on iPhone (and probably more that I haven't tested). It does not work in Internet Explorer.

<h2 id="similar">Similar packages</h2>

As mentioned above, the libraries used by {shinyscreenshot} do have limitations and may not always work. There are two other packages that came out recently that also provide screenshot functionality which you may try and compare: [{snapper}](https://github.com/yonicd/snapper) by Jonathan Sidi and [{capture}](https://github.com/dreamRs/capture) by dreamRs.

RStudio's [{webshot}](https://github.com/wch/webshot) package is also similar, but serves a very different purpose. {webshot} is used to take screenshots of any website (including Shiny apps), but you cannot interact with the page in order to take a screenshot at a specific time.

<h2 id="sponsors">Sponsors 🏆</h2>

> There are no sponsors yet

[Become the first sponsor for
{shinyscreenshot}\!](https://github.com/sponsors/daattali/sponsorships?tier_id=39856)
