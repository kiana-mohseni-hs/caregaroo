$ ->  
#pick up toggle change
  $(".submit_on_change").change ->
    form = $(this).closest("form")
    form.get(0).submit()
