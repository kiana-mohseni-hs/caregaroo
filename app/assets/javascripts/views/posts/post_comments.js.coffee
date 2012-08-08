class Cg2App.Views.PostComments extends Backbone.View

  template: JST['posts/comments']
  
  events:
    'submit #new_post_comment': 'createComment'
  
  initialize: ->
    @collection.on('add', @prependComment, this)

  render: ->
    $(@el).html(@template())
    @collection.each(@appendComment)
    this
  
  prependComment: (comment) =>
    view = new Cg2App.Views.PostComment(model: comment)
    @$('#post_comments').prepend(view.render().el)

  appendComment: (comment) =>
    view = new Cg2App.Views.PostComment(model: comment)
    @$('#post_comments').append(view.render().el)
    
  createComment: (event) ->
    event.preventDefault()
    attributes = 
      content: $('#new_post_comment_content').val()
      post_id: @options.post_id
      author: true
      user: 
        id: window.currentUser.id
        first_name: window.currentUser.first_name
        thumb_url: window.currentUser.thumb_url 
    @collection.create attributes,
      wait: true
      success: -> $('#new_post_comment')[0].reset()
      # error: @handleError
