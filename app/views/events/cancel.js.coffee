$('.<%= dom_id(@event) %>')
  .fadeOut ->
    $(this).prev().remove() if $(this).prev().hasClass("events_list_date_row") and ( $(this).next().hasClass("events_list_date_row") or $(this).is(':last-child') )
    $('.<%= dom_id(@event) %>').hide()
