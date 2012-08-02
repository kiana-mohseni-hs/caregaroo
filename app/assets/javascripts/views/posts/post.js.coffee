class Cg2App.Views.Post extends Backbone.View
  template: JST['posts/post']
  tagName: 'li'
  
  events:
    'click .delete_post': 'destroy'
    'click .show_comments': 'comments'
  
  initialize: ->
    @model.on('change', @render, this)
    @model.comments.on('remove', @decreaseCount, this)
    
  render: ->
    $(@el).html(@template(post: @model))
    this

  destroy: (event) ->
    event.preventDefault()    # prevents url from being logged
    confirm_result = confirm("Delete Post: Are you sure?")
    if confirm_result is true
      @model.destroy()
      @remove()

  comments: ->
    view = new Cg2App.Views.PostComments(collection: @model.comments)
    $('#post').html(view.render().el)

  decreaseCount: ->
    $("\#post_comments_count_#{@model.id}").html(@model.comments.length)