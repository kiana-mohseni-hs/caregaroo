class Cg2App.Views.PostComment extends Backbone.View
  template: JST['posts/comment']
  tagName: 'li'
  
  events:
    'click .delete_comment': 'destroy'
  
  render: ->
    $(@el).html(@template(comment: @model))
    this

  destroy: (event) ->
    event.preventDefault()    # prevents url from being logged
    confirm_result = confirm("Delete Comment: Are you sure?")
    if confirm_result is true
      @model.destroy()
      @remove()

