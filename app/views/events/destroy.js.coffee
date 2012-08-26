$('#<%= dom_id(@event) %>')
  .fadeOut ->
    $(this).remove()