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
    onClose: (dateText, inst) ->
      unless endDateTextBox.val() is ""
        testStartDate = startDateTextBox.datetimepicker("getDate")
        testEndDate = endDateTextBox.datetimepicker("getDate")
        endDateTextBox.datetimepicker "setDate", testStartDate  if testStartDate > testEndDate
      else
        endDateTextBox.val dateText

    onSelect: (selectedDateTime) ->
      endDateTextBox.datetimepicker "option", "minDate", startDateTextBox.datetimepicker("getDate")

  endDateTextBox.datetimepicker
    onClose: (dateText, inst) ->
      unless startDateTextBox.val() is ""
        testStartDate = startDateTextBox.datetimepicker("getDate")
        testEndDate = endDateTextBox.datetimepicker("getDate")
        startDateTextBox.datetimepicker "setDate", testEndDate  if testStartDate > testEndDate
      else
        startDateTextBox.val dateText

    onSelect: (selectedDateTime) ->
      startDateTextBox.datetimepicker "option", "maxDate", endDateTextBox.datetimepicker("getDate")

