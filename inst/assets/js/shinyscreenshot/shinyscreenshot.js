Shiny.addCustomMessageHandler('screenshot', function(params) {
  setTimeout(function() { shinyscreenshot.takeScreenshot(params) }, params.timer*1000);
});

var shinyscreenshot = {
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
      saveAs(img, params.filename);
    });
  }
};
