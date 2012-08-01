class Cg2App.Views.PostComment extends Backbone.View

  template: JST['posts/comment']
  
  render: ->
    $(@el).html(@template(comment: @model))
    this
