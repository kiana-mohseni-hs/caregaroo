window.Cg2App =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: -> 
    new Cg2App.Routers.Posts
<<<<<<< HEAD
    new Cg2App.Routers.Profiles
=======
    new Cg2App.Routers.Profile
>>>>>>> 7dd03b1aa6a0585cab5ac3e4a6fb09a6e6fde0d9
    Backbone.history.start()
    
$(document).ready ->
  Cg2App.init()
