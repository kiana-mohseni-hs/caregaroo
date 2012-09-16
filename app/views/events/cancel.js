$('#<%= dom_id(@event) %>').fadeOut(function() {
  if ($(this).prev().hasClass("events_list_date_row") && $(this).next().hasClass("events_list_date_row")) {
    $(this).prev().remove();
  }
  return $(this).remove();
});
