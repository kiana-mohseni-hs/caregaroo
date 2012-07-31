class Cg2App.Views.Post extends Backbone.View
  template: JST['posts/post']
  tagName: 'li'
  
  events:
    'click .delete_post': 'destroy'
  
  initialize: ->
    @model.on('change', @render, this)
    
  render: ->
    $(@el).html(@template(post: @model))
    this

  destroy: (event) ->
    event.preventDefault()    # prevents url from being logged
    confirm_result = confirm("Delete Post: Are you sure?")
    if confirm_result is true
      @model.destroy()
      @remove()
