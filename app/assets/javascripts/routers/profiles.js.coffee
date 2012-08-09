class Cg2App.Routers.Profiles extends Backbone.Router
  routes:
    "profile": 'index'
    
  index: ->
    view = new Cg2App.Views.ProfilesIndex()
    $('#profile').html("Profile page")
