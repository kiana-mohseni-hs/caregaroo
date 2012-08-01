window.Cg2App =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: -> 
    new Cg2App.Routers.Posts
    Backbone.history.start()
    
$(document).ready ->
  Cg2App.init()
