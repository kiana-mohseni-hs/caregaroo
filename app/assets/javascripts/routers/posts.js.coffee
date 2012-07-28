class Cg2App.Routers.Posts extends Backbone.Router
  routes:
    "*actions": 'index'
    # 'posts/:id': 'show'
    
  initialize: ->
    @collection = new Cg2App.Collections.Posts()
    @collection.fetch()
                
  index: ->
    view = new Cg2App.Views.PostsIndex(collection: @collection)
    $('#journal').html(view.render().el)
  
  # show: (id) ->
  #   alert "Post #{id}"
