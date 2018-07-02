$(document).on("turbolinks:load", function() {

  var nInitialCount = 1500; //Intial characters to display

  var moretext = "Read more";

  var lesstext = "Read less";

  $(".longtext").each(function() {
    var paraText = $(this).html();

    if (paraText.length > nInitialCount) {

      var sText = paraText.substr(0, nInitialCount);

      var eText = paraText.substr(nInitialCount, paraText.length - nInitialCount);

      var newHtml = sText + eText + "" + "";

      $(this).html(newHtml);
    } else {
      $(".links").remove();
    }
  });

  $(".links").on("click", function(e) {
    var lnkHTML = $(this).html();

    if (lnkHTML == lesstext) {
      $(this).html(moretext);
    } else {
      $(this).html(lesstext);
    }

    $(this).prev().toggle();
    $(".lesstext").toggle();
    e.preventDefault();
  });
});
