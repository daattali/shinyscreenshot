Shiny.addCustomMessageHandler('screenshot', function(params) {
  var element = $(params.selector)[0];

  var brokenSliders = $(element).find(".irs-line");
  brokenSliders.attr("data-html2canvas-ignore", "");

  html2canvas(element, { scale : params.scale }).then(function(canvas) {
    img = canvas.toDataURL();
    // saveFile(img, params.filename);
    saveAs(img, params.filename);
  });
});
