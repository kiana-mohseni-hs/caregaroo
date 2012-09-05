$.jQTouch
  icon: "/assets/mobile/homescreen.png"
  startupScreen: "/assets/mobile/splash.png"
$ ->  
  $('#calendardisplay').getCalendar()  #getCalendar(date: new Date("July 9,1967"))
  updateDisplay()
  
  $('#calendardisplay').find("td").bind "click", ->
    updateDisplay($(this).attr('datetime'))

  clicktouch = "click"
  clicktouch = "touchstart"  if Modernizr.touch
  
  # go to today in month view
  $('a#today').bind clicktouch, ->
    setDate(shortFormatDate(new Date()))
  
  # switch to day view from month view
  $('a#dayview').bind clicktouch, ->
    updateDisplay()

  $('#previousday').bind clicktouch, ->
    setDate(shortFormatDate(getOtherDate(-1)))

  $('#nextday').bind clicktouch, ->
    setDate(shortFormatDate(getOtherDate(1)))

  # go to today in day view
  $('a#today-day').bind clicktouch, ->
    setDate(shortFormatDate(new Date()))
    
  $('.event_item').bind clicktouch, ->
    event_id = $(this).attr("id").slice(6)
    $("#event").html($(this).html())
    
  #hack to make form submit work or jqtouch hijacks it
  $('.ensure_submit').submit ->
    @submit()
    false

  #confirm submission and work around jqtouch
  $('.confirm_delete').submit ->
    confirm_result = confirm("Delete Event: Are you sure?")
    @submit() if confirm_result is true
    false
    
  #confirm event comment delete
  $('.delete_event_comment').click ->
    confirm("Delete Comment: Are you sure?")
 
  #pick up the toggle change in events/show ("participating?")
  $(".submit_on_change").change ->
    form = $(this).closest("form")
    form.get(0).submit()
    
  #highlight section of bottom tabbar
  $('.tabbar>ul>li>a').bind clicktouch, ->
    $(this).parent('li').siblings().removeClass('current');
    $(this).parent('li').addClass('current');
  
  #hide the tabbar in event add form
  $('.add_event_button').bind clicktouch, ->
    $('#other').hide()
  $('.cancel').bind clicktouch, ->
    $('#other').show()
  
# update list of visible events and set title in day view to currently selected date
updateDisplay = (date) ->
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
  new Date(dateObject($("#calendardisplay").find('.selected').attr('datetime'))) || new Date()

getOtherDate = (differenceInDays = 1) ->
  currentDate = getCurrentDateObject()
  currentDate.setDate(currentDate.getDate() + differenceInDays );
  currentDate

setSelectedDate = (date) ->
  $("#calendardisplay").find('.selected').removeClass("selected")
  $('#calendardisplay').getCalendar(date: new Date(dateObject(date))) if $("[datetime='#{date}']").length is 0
  $("[datetime='#{date}']").addClass("selected")
  
setDate = (newShortDate) ->
  setSelectedDate(newShortDate)
  updateDisplay(newShortDate)
    
setDayViewDate = (date) ->
  $("#dayviewdate").html(dateObject(date).toLocaleDateString())

# Add leading zero to month and day where necessary
formattedDate = (date) ->
  dateAr = date.split("-")
  dateAr[1] = "0" + dateAr[1] if (dateAr[1].length == 1)
  dateAr[2] = "0" + dateAr[2] if (dateAr[2].length == 1)
  dateAr.join("-")
  
shortFormatDate = (date) ->
  date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate()

dateObject = (shortDate) ->
  $("#calendardisplay").stringToDate(shortDate)
