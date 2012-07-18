$.jQTouch
  icon: "/assets/mobile/homescreen.png"
  startupScreen: "/assets/mobile/splash.png"
$ ->  
  $('#calendardisplay').getCalendar()  #getCalendar(date: new Date("July 9,1967"))
  setDayViewTitle()
  
  $('#calendardisplay').find("td").bind "click", ->
    setDayViewTitle($(this).attr('datetime'))

  # set title in day view to today's date on load
  $('#dayviewdate').html((new Date()).toLocaleDateString())

  clicktouch = "click"
  clicktouch = "touchstart"  if Modernizr.touch
  
  #reload calendar
  $('a#today').bind clicktouch, ->
    $("#calendardisplay").getCalendar()
  
  $('a#dayview').bind clicktouch, ->
    setDayViewTitle()

  $('#previousday').bind clicktouch, ->
    displayDayViewDate(shortFormatDate(getOtherDate(-1)))

  $('#nextday').bind clicktouch, ->
    displayDayViewDate(shortFormatDate(getOtherDate(1)))

  #reload calendar
  $('a#today-day').bind clicktouch, ->
    $("#calendardisplay").getCalendar()
    setDayViewTitle()
    
  $('.event_item').bind clicktouch, ->
    event_id = $(this).attr("id").slice(6)
    $("#event").html($(this).html())
    
  #hack to make form submit work or jqtouch hijacks it
  $('.ensure_submit').submit ->
    @submit()
    false

  #confirm submission and work around jqtouch
  $('.confirm_delete').submit ->
    confirm_result = confirm("Delete: Are you sure?")
    @submit() if confirm_result is true
    false
    
  #pick up the toggle change in events/show ("participating?")
  $(".submit_on_change").change ->
    form = $(this).closest("form")
    form.get(0).submit()
  
# update list of visible events and set title in day view to currently selected date
setDayViewTitle = (date) ->
  selectedDate = date || getCurrentShortDate()
  setDayViewDate(selectedDate)
  FormattedDate = formattedDate(selectedDate)
  
  visible_events = $("#dayviewevents>li>a").children('[datetime^="' + FormattedDate + '"]').parent().parent()
  
  $("#dayviewevents>li").hide()
  visible_events.show()
  
  $(".events").empty().append(visible_events.parent().html())
  
getCurrentShortDate = ->
  today = new Date()
  selectedDate = $("#calendardisplay").find('.selected').attr('datetime')  || shortFormatDate(today)
  
getCurrentDateObject = ->
  new Date($("#calendardisplay").stringToDate($("#calendardisplay").find('.selected').attr('datetime'))) || new Date()

getOtherDate = (differenceInDays = 1) ->
  currentDate = getCurrentDateObject()
  currentDate.setDate(currentDate.getDate() + differenceInDays );
  currentDate

setSelectedDate = (date) ->
  $("#calendardisplay").find('.selected').removeClass("selected")
  $("[datetime='#{date}']").addClass("selected")
  
displayDayViewDate = (newShortDate) ->
  setSelectedDate(newShortDate)
  setDayViewTitle(newShortDate)
    
setDayViewDate = (date) ->
  $("#dayviewdate").html($("#calendardisplay").stringToDate(date).toLocaleDateString())

# Add leading zero to month and day where necessary
formattedDate = (date) ->
  dateAr = date.split("-")
  dateAr[1] = "0" + dateAr[1] if (dateAr[1].length == 1)
  dateAr[2] = "0" + dateAr[2] if (dateAr[2].length == 1)
  dateAr.join("-")
  
shortFormatDate = (date) ->
  date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate()