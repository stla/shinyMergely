var selectize;

function onInitialize() {
  $(".well").show();
  $(".sky")
    .css("visibility", "visible")
    .effect("bounce", {duration: 1500, distance: 50}, function() {
      $(".night").animate({opacity: 1}, 1500);
    });
  selectize = this;
}

function start(_) {
  $(".sky").hide();
  $(".mainPanel").animate({opacity: 1}, 1500);
  $("body").css("overflow", "auto");
}

var o = {
  height: "60vh",
  viewport: false,
  sidebar: false,
  autoresize: true,
  wrap_lines: true,
  cmsettings: {
    readOnly: false,
    lineWrapping: true,
    theme: "cobalt",
    mode: "text/plain"
  }
};

function mergely(texts) {
  $(".files").removeClass("underline");
  $("#fileLeft,#fileRight").hide("fade", {duration: 1000});
  $("#mergely").remove();
  $("#mergely-container").append($("<div id='mergely'></div>"));
  $("#mergely").mergely(o);
  $("#mergely").mergely("lhs", texts.lhs);
  $("#mergely").mergely("rhs", texts.rhs);
  setTimeout(function() {
    $("#mergely").mergely("scrollTo", "lhs", 1);
    $("#mergely").mergely("scrollTo", "rhs", 1);
  }, 500);
}

function setMode(mode) {
  $("#mergely").mergely("cm", "lhs").setOption("mode", mode);
  $("#mergely").mergely("cm", "rhs").setOption("mode", mode);
}

function setFileNames(names) {
  $("#copyLeft,#copyRight").show();
  $("#fileLeft").text(names.left);
  $("#fileRight").text(names.right);
  $("#fileLeft,#fileRight").show("fade", {duration: 1000}, function() {
    setTimeout(function() {
      $(".files").addClass("underline");
    }, 1000);
  });
}


$(document).ready(function() {

  $("[data-toggle=tooltip]").tooltip().on("hidden.bs.tooltip", function() {
    var $this = $(this);
    setTimeout(function() {
      $this.tooltip("destroy");
    }, 10000);
  });

  $(window).resize(function() {
    setTimeout(function() {
      $("#mergely").mergely("resize");
    });
  });

  $("#mergely-container").on("resizestop", function(event, ui) {
    setTimeout(function() {
      $("#mergely").mergely("resize");
    }, 500);
  });

  $("#close").on("click", function() {
    $(".well").hide("fold", {duration: 2000}, function() {
      $("#mergely").mergely("resize");
    });
  });

  $("#copyLeft").on("click", function() {
    navigator.clipboard.writeText($("#mergely").mergely("get", "lhs"));
  });

  $("#copyRight").on("click", function() {
    navigator.clipboard.writeText($("#mergely").mergely("get", "rhs"));
  });

  $("#prevDiff").on("click", function() {
    $("#mergely").mergely("scrollToDiff", "prev");
  });

  $("#nextDiff").on("click", function() {
    $("#mergely").mergely("scrollToDiff", "next");
  });

  document.getElementById("files").addEventListener("change", function() {
    if(document.getElementById("files").files.length === 2) {
      $("label[for=files]").next().find(".form-control")
        .css("border-bottom-right-radius", 0);
      $(this).parent().css("border-bottom-left-radius", 0);
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
        speed: "slow"
      });
      this.value = "";
      return false;
    }
  });
});

function changeBorders(id) {
  $(`label[for=${id}]`).next().find(".form-control")
    .css("border-bottom-right-radius", 0);
  $(`#${id}`).parent().css("border-bottom-left-radius", 0);
}

function flashMessage(opts) {
  $.alert(opts.message, {
    title: opts.title || null,
    type: opts.type || "info",
    icon: opts.icon || false,
    withTime: opts.withTime || false,
    autoClose: opts.autoClose === false ? false : true,
    closeTime: opts.closeTime || 5000,
    animation: opts.animation || true,
    animShow: opts.animShow || "rotateInDownRight",
    animHide: opts.animHide || "bounceOutLeft",
    position: opts.position || ["bottom-right", [0, 0.01]],
    speed: "slow"
  });
}


$(document).on("shiny:connected", function() {
  Shiny.addCustomMessageHandler("mergely", mergely);
  Shiny.addCustomMessageHandler("setMode", setMode);
  Shiny.addCustomMessageHandler("fileNames", setFileNames);
  Shiny.addCustomMessageHandler("swap", function(x) {
    $("#mergely").mergely("swap");
  });
  Shiny.addCustomMessageHandler("start", start);
  Shiny.addCustomMessageHandler("changeBorders", changeBorders);
  Shiny.addCustomMessageHandler("flashMessage", flashMessage);
});
