var shinyscreenshot = {
  initScreenshot : function(params) {
    setTimeout(function() { shinyscreenshot.takeScreenshot(params) }, params.timer*1000);
  },

  takeScreenshot : function(params) {
    var element = $(params.selector)[0];
    html2canvas(
      element, {
        scale : params.scale,
        logging : false,
        useCORS : true
      }
    ).then(function(canvas) {
      var img = canvas.toDataURL();
      if (params.server_dir !== null) {
        Shiny.setInputValue(
          `${params.namespace}shinyscreenshot:shinyscreenshot`,
          { image: img, filename : params.filename, dir : params.server_dir },
          { priority : "event" }
        );
      }
      if (params.download) {
        saveAs(img, params.filename);
      }
    });
  },

  screenshotButton : function(id) {
    var params = $("#" + id).data("shinyscreenshot-params");
    shinyscreenshot.initScreenshot(params);
  }
};

Shiny.addCustomMessageHandler('screenshot', shinyscreenshot.initScreenshot);
