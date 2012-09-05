class Cg2App.Routers.Posts extends Backbone.Router
  routes:
    "journal": 'index'
    
  initialize: ->
    @posts = new Cg2App.Collections.Posts()
    @posts.fetch()
    
  index: ->
    view = new Cg2App.Views.PostsIndex(collection: @posts)
    $('#journal').html(view.render().el)

  