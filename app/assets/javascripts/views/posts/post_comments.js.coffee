class Cg2App.Views.PostComments extends Backbone.View

  template: JST['posts/comments']
  
  events:
    'submit #new_post_comment': 'createComment'
  
  initialize: ->
    @model.comments.on('add', @prependComment, this)

  render: ->
    $(@el).html(@template())
    @model.comments.each(@appendComment)
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
      post_id: @model.id
      author: true
      user: 
        id: window.currentUser.id
        first_name: window.currentUser.first_name
        thumb_url: window.currentUser.thumb_url 
    @model.comments.create(attributes, at: 0)
    $('#new_post_comment')[0].reset()                                             # clear the form input field
    $("\#post_comments_count_#{@model.id}").html(@model.comments.length)       # update the number of comments for the post
