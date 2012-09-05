class Cg2App.Views.ProfilesIndex extends Backbone.View

  template: JST['profiles/index']

  render: ->
    $(@el).html(@template())
    this
