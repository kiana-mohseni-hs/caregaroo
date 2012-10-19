class Cg2App.Routers.Profile extends Backbone.Router
  routes:
    'profile': 'index'

  # initialize: ->
  #   @profile = new Cg2App.Model.Profile()
  #   @profile.fetch()
	  
  index: ->
    view = new Cg2App.Views.ProfileIndex()
    console.log 'profile'
    # $('#profile').html(view.render().el)

