window.Cg2App =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: -> 
    new Cg2App.Routers.Posts
    new Cg2App.Routers.Profiles
    Backbone.history.start()
    
$(document).ready ->
  Cg2App.init()
