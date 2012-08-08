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
    comment = @collection.create attributes
    # post = Posts.get(@options.post_id)
    # @options.post.comments.add(comment)
    $('#new_post_comment')[0].reset()                                             # clear the form input field
    $("\#post_comments_count_#{@options.post_id}").html(@collection.length)       # update the number of comments for the post
