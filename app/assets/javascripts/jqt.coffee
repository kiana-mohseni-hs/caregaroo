$.jQTouch icon: "img/homescreen.png"
$ ->
  $("#calendardisplay").getCalendar()
  $("a#today").click ->
    $("#calendardisplay").getCalendar()