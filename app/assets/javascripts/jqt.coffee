$.jQTouch
  icon: "/assets/mobile/homescreen.png"
  startupScreen: "/assets/mobile/splash.png"
$ ->  
  $('#calendardisplay').getCalendar()

  # set title in day view to today's date on load
  $('#dayviewdate').html((new Date()).toLocaleDateString())

  clicktouch = "click"
  clicktouch = "touchstart"  if Modernizr.touch
  
  #reload calendar
  $('a#today').bind clicktouch, ->
    $("#calendardisplay").getCalendar()
  
  $('a#dayview').bind clicktouch, ->
    setDayViewTitle()

  #reload calendar
  $('a#today-day').bind clicktouch, ->
    $("#calendardisplay").getCalendar()
    setDayViewTitle()
    
  $('.event_item').bind clicktouch, ->
    event_id = $(this).attr("id").slice(6)
    $("#event").html($(this).html())
    
  #hack to make submit work or jqtouch hijacks it
  $('#new_event').submit ->
    @submit()
  
  #hack to make submit work or jqtouch hijacks it
  $('.edit_event').submit ->
    @submit()
  $('.delete_event_button').submit ->
    @submit()
   
    
  # if $('#add_event').hasClass('current')
  #   $('#other').hide()
  # else
  #   $('#other').show()
  

  # $('.add_event_button').click ->
  #   $('#other').hide()
  
  # $("input[type=\"checkbox\"]").change() ->
  #   alert "changed"
  
  # $('.toggle>input').click ->
  #   unless $(this).is(':checked')
  #   alert( "checked")
  
  # $(":checkbox").attr("checked").change ->
  #     if $(this).attr("checked")
  #       alert "hey"
  #     else
  #       alert "hey hey"
      
# set title in day view to currently selected date
setDayViewTitle = ->
  selectedDate = $("#calendardisplay").find('.selected').attr('datetime')
  $("#dayviewdate").html($("#calendardisplay").stringToDate(selectedDate).toLocaleDateString())

  # Add leading zero to month and day where necessary
  dateAr = selectedDate.split("-")
  dateAr[1] = "0" + dateAr[1] if (dateAr[1].length == 1)
  dateAr[2] = "0" + dateAr[2] if (dateAr[2].length == 1)
  FormattedDate = dateAr.join("-")

  $("#dayviewevents>li").hide()
  $("#dayviewevents>li>a").children('[datetime^="' + FormattedDate + '"]').parent().parent().show()
  
  
  
