$.jQTouch
  icon: "/assets/mobile/homescreen.png"
  startupScreen: "/assets/mobile/splash.png"
$ ->
  $("#calendardisplay").getCalendar()

  # set title in day view to today's date on load
  $("#dayviewdate").html((new Date()).toLocaleDateString())

  #reload calendar
  $("a#today").bind "touchstart", ->
    $("#calendardisplay").getCalendar()
  
  # set title in day view to currently selected date
  $("a#dayview").bind "touchstart", ->
    selectedDate = $("#calendardisplay").find('.selected').attr('datetime')
    $("#dayviewdate").html($("#calendardisplay").stringToDate(selectedDate).toLocaleDateString())

    # Add leading zero to month and day where necessary
    dateAr = selectedDate.split("-")
    dateAr[1] = "0" + dateAr[1] if (dateAr[1].length == 1)
    dateAr[2] = "0" + dateAr[2] if (dateAr[2].length == 1)
    FormattedDate = dateAr.join("-")
        
    $("#dayviewevents>li").hide()
    $("#dayviewevents>li").children('[datetime^="' + FormattedDate + '"]').parent().show()

  #reload calendar
  $("a#today-day").bind "touchstart", ->
    $("#calendardisplay").getCalendar()

    selectedDate = $("#calendardisplay").find('.selected').attr('datetime')
    $("#dayviewdate").html($("#calendardisplay").stringToDate(selectedDate).toLocaleDateString())

    # Add leading zero to month and day where necessary
    dateAr = selectedDate.split("-")
    dateAr[1] = "0" + dateAr[1] if (dateAr[1].length == 1)
    dateAr[2] = "0" + dateAr[2] if (dateAr[2].length == 1)
    FormattedDate = dateAr.join("-")
        
    $("#dayviewevents>li").hide()
    $("#dayviewevents>li").children('[datetime^="' + FormattedDate + '"]').parent().show()
