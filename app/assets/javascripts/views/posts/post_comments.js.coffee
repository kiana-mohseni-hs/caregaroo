class Cg2App.Views.PostComments extends Backbone.View

  template: JST['posts/comments']
  className: 'edgetoedge'
  
  
  render: ->
    $(@el).html(@template(comments: @collection))
    this
  # render: ->
  #   $(@el).html(@template())
  #   @collection.each(@appendComment)
  #   this
  # 
  # appendComment: (comment) =>
  #   view = new Cg2App.Views.PostComment(model: comment)
  #   @$('#post_comments').append(view.render().el)
  # 