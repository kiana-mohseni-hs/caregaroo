class Cg2App.Models.Post extends Backbone.Model
  
  initialize: ->
    @comments = new Cg2App.Collections.Comments
    @comments.reset(@get('comments'))
