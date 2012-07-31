class Cg2App.Views.PostsIndex extends Backbone.View

  template: JST['posts/index']
  
  events:
    'submit #new_post': 'createPost'
    
  
  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @prependPost, this)

  render: ->
    $(@el).html(@template())
    @collection.each(@appendPost)
    this

  prependPost: (post) =>
    view = new Cg2App.Views.Post(model: post)
    @$('#posts').prepend(view.render().el)

  appendPost: (post) =>
    view = new Cg2App.Views.Post(model: post)
    @$('#posts').append(view.render().el)
  
  createPost: (event) ->
    event.preventDefault()
    attributes = 
      content: $('#new_post_content').val()
      author: true
      commentscount: 0
      user: 
        id: window.currentUser.id
        first_name: window.currentUser.first_name
        thumb_url: window.currentUser.thumb_url 
    @collection.create attributes,
      wait: true
      success: -> $('#new_post')[0].reset()
      error: @handleError
  
  handleError: (post, response) ->
    if response.status == 422
      errors = $.parseJSON(response.responseText).errors
      for attribute, messages of errors
        alert "#{attribute} #{message}" for message in messages
