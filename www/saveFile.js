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

// heavily borrowed from plotly.js
var saveFile = function(url, filename) {
    var saveLink = document.createElement('a');
    var canUseSaveLink = 'download' in saveLink;
    var isSafari = /Version\/[\d\.]+.*Safari/.test(navigator.userAgent);
    // IE <10 is explicitly unsupported
    if (typeof navigator !== 'undefined' && /MSIE [1-9]\./.test(navigator.userAgent)) {
        alert('Download not supported in IE < 10');
    }

    // First try a.download, then web filesystem, then object URLs
    if (isSafari) {
        // Safari doesn't allow downloading of blob urls
        document.location.href = 'data:application/octet-stream' + url.slice(url.search(/[,;]/));
        return;
    }

    if (canUseSaveLink) {
        saveLink.href = url;
        saveLink.download = filename;
        document.body.appendChild(saveLink);
        saveLink.click();
        document.body.removeChild(saveLink);
        return;
    }

    // IE 10+ (native saveAs)
    if(typeof navigator !== 'undefined' && navigator.msSaveBlob) {
        // At this point we are only dealing with a SVG encoded as
        // a data URL (since IE only supports SVG)
        var encoded = url.split(/^data:image\/svg\+xml,/)[1];
        var svg = decodeURIComponent(encoded);
        navigator.msSaveBlob(new Blob([svg]), filename);
        return;
    }

    alert('Download error');
};
