var o = {
    //width: "auto",
    height: "60vh",
    //editor_width: "calc(100%)",
//    editor_height: "60vh",
    viewport: false,
    sidebar: false,
    autoresize: true,
//    lhs: function(setValue){setValue("a\na\na\na\na\na\na\na\na\na\n");},
//    rhs: function(setValue){setValue("a\na\nb\na\nb\na\na\na\na\na\n");},
    wrap_lines: true,
    cmsettings: {
      readOnly: false,
      lineWrapping: true,
      theme: "cobalt",
      mode: "text/plain"
    },
    license: null
  };
function mergely(texts) {
  $("#mergely").remove();
  $("#x").append($("<div id='mergely'></div>"));
  $("#mergely").mergely(o);
/*  $('#mergely').mergely('clear', 'lhs');
  $('#mergely').mergely('clear', 'rhs');
  $('#mergely').mergelyUnregister();
  $('#mergely').mergely("update"); */
  $("#mergely").mergely("lhs", texts.lhs);
  $("#mergely").mergely("rhs", texts.rhs);
}
function setMode(mode) {
  $("#mergely").mergely("cm", "lhs").setOption("mode", mode);
  $("#mergely").mergely("cm", "rhs").setOption("mode", mode);
}
function setFileNames(names) {
  $("#copyLeft,#copyRight").show();
  $("#fileLeft").text(names.left);
  $("#fileRight").text(names.right);
}
$(document).on("shiny:connected", function() {
  Shiny.addCustomMessageHandler("mergely", mergely);
  Shiny.addCustomMessageHandler("setMode", setMode);
  Shiny.addCustomMessageHandler("fileNames", setFileNames);
  Shiny.addCustomMessageHandler("swap", function(x) {
    $("#mergely").mergely("swap");
  });
});

$(document).ready(function() {
  $(".sky").effect("bounce", {duration: 1500, distance: 50});
  setTimeout(function() {
    $(".night").animate({opacity: 1}, 1500);
  }, 1500);
  $("#copyLeft").on("click", function() {
    navigator.clipboard.writeText($("#mergely").mergely("get", "lhs"));
  });
  $("#copyRight").on("click", function() {
    navigator.clipboard.writeText($("#mergely").mergely("get", "rhs"));
  });
/*  $("#mergely").mergely({
    width: "auto",
    height: "60vh",
//    editor_width: "auto",
//    editor_height: "60vh",
    viewport: false,
    sidebar: false,
    autoresize: true,
//    lhs: function(setValue){setValue("a\na\na\na\na\na\na\na\na\na\n");},
//    rhs: function(setValue){setValue("a\na\nb\na\nb\na\na\na\na\na\n");},
    wrap_lines: true,
    cmsettings: {
      readOnly: false,
      lineWrapping: true,
      theme: "cobalt",
      mode: "text/plain"
    },
  });*/

/*setTimeout(function(){
var watchResize = new WatchElementResize(document.querySelectorAll(".CodeMirror")[0]);
watchResize.on('resize', function(evt){
  console.info(evt);

  // the DOM element
  var resized_element = evt.element.target;

  // the element offset (width, height, top, left)
  var offset = evt.element.offset;

  // the window dimensions -- just in case you need
  var window_size = evt.window;
});
},500);*/


  document.getElementById("files").addEventListener("change", function() {
    if(document.getElementById("files").files.length === 2) {
      $(".sky").hide();
      $(".mainPanel").animate({opacity: 1}, 1500);
      $("body").css("overflow", "auto");
      return true;
    } else {
      $.alert("You have to upload <u>two</u> files", {
        title: "Upload two files!",
        type: "danger",
        icon: "glyphicon glyphicon-ban-circle",
        withTime: true,
        autoClose: true,
        closeTime: 10000,
        animation: true,
        animShow: "flash",
        animHide: "backOutDown",
        position: ["center", [0, 0]],
        speed: "slow",
      });
      this.value = "";
      return false;
    }
  });
});
