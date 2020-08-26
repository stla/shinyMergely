function mergely(texts) {
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
  $("#copyLeft").on("click", function() {
    navigator.clipboard.writeText($("#mergely").mergely("get", "lhs"));
  });
  $("#copyRight").on("click", function() {
    navigator.clipboard.writeText($("#mergely").mergely("get", "rhs"));
  });
  $("#mergely").mergely({
    width: "auto",
    height: "400px",
    wrap_lines: true,
    cmsettings: {
      readOnly: false,
      lineWrapping: true,
      theme: "cobalt",
      mode: "text/plain"
    },
  });
  document.getElementById("files").addEventListener("change", function() {
    if(document.getElementById("files").files.length === 2) {
      $(".mainPanel").animate({opacity: 1}, 1500);
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
