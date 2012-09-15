$ ->  
#pick up toggle change in events list page
  $(".event_sign_up").click ->
    $.ajax
      url: $(this).data("href")
      type: "PUT"
      data:
        checked: $(this).is(":checked")
      dataType: "html"
      success: (data, textStatus, jqXHR) ->
        $(data).purr usingTransparentPNG: true
        false
#link start and end dates in event form
  startDateTextBox = $("#event_start_at")
  endDateTextBox = $("#event_end_at")
  startDateTextBox.datetimepicker
    dateFormat: 'yy-mm-dd'
    ampm: true
    amNames: ['AM', 'A', 'am', 'a']
    pmNames: ['PM', 'P', 'pm', 'p']
    timeFormat: 'h:mm tt'
    stepMinute: 5
    # showTimezone: true
    # timezone: 'PT',
    # timezoneList: [ { value: 'ET', label: 'Eastern'}, { value: 'CT', label: 'Central' }, { value: 'MT', label: 'Mountain' }, { value: 'PT', label: 'Pacific' } ]
    onClose: (dateText, inst) ->
      if endDateTextBox.val() is ""
        endDateTextBox.val dateText
      else
        testStartDate = startDateTextBox.datetimepicker("getDate")
        testEndDate = endDateTextBox.datetimepicker("getDate")
        endDateTextBox.datetimepicker "setDate", testStartDate  if testStartDate > testEndDate

    onSelect: (selectedDateTime) ->
      endDateTextBox.datetimepicker "option", "minDate", startDateTextBox.datetimepicker("getDate")      

  endDateTextBox.datetimepicker
    dateFormat: 'yy-mm-dd'
    ampm: true
    amNames: ['AM', 'A', 'am', 'a']
    pmNames: ['PM', 'P', 'pm', 'p']
    timeFormat: 'h:mm tt'
    stepMinute: 5
    onClose: (dateText, inst) ->
      if startDateTextBox.val() is ""
        startDateTextBox.val dateText
      else
        testStartDate = startDateTextBox.datetimepicker("getDate")
        testEndDate = endDateTextBox.datetimepicker("getDate")
        startDateTextBox.datetimepicker "setDate", testEndDate  if testStartDate > testEndDate

    onSelect: (selectedDateTime) ->
      startDateTextBox.datetimepicker "option", "maxDate", endDateTextBox.datetimepicker("getDate")

