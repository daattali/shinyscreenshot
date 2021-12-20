# shinyscreenshot 0.2.0 (2021-12-20)

- New feature: the screenshot image can now be saved on the server using `server_dir` parameter. If the save is successful, `input$shinyscreenshot` holds the image path. Also added `download` parameter to specify whether to download the image to the app's user, and `ns` parameter to `screenshotButton` so that saving will work in modules. (#3)
- Performance: improve performance by only attempting to load the required scripts once.

# shinyscreenshot 0.1.0 (2020-10-13)

Initial release
