class Cg2App.Routers.Posts extends Backbone.Router
  routes:
    "journal": 'index'
    # 'posts/:id': 'show'
    
  initialize: ->
    @collection = new Cg2App.Collections.Posts()
    @collection.fetch()
    # @current_user = new Cg2App.Models.CurrentUser()
    # @current_user.fetch()
    
  index: ->
    view = new Cg2App.Views.PostsIndex(collection: @collection)
    $('#journal').html(view.render().el)

  # show: (id) ->
  #   alert "Post #{id}"
  