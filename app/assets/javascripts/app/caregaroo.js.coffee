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
    
