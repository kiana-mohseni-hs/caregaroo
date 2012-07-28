class Cg2App.Views.Post extends Backbone.View
  template: JST['posts/post']
  tagName: 'li'
  
  initialize: ->
    @model.on('change', @render, this)
    
  render: ->
    $(@el).html(@template(post: @model))
    this
