class Cg2App.Views.PostsIndex extends Backbone.View

  template: JST['posts/index']
  
  initialize: ->
    @collection.on('reset', @render, this)

  render: ->
    $(@el).html(@template())
    @collection.each(@appendPost)
    this

  appendPost: (post) =>
    view = new Cg2App.Views.Post(model: post)
    @$('#posts').append(view.render().el)