//= require modernizr
//= require jquery
//= require mobile/jqtouch-jquery
//= require mobile/jqtouch
//= require mobile/jqt.calendar
//= require mobile/caregaroo
//
//
//= require underscore
//= require backbone
//
//= require .//cg2_app
//
//= require_tree ../templates/
//= require_tree .//models
//= require_tree .//collections
//= require_tree .//views
//= require_tree .//routers


// Rails CSRF Protection
$(document).ajaxSend(function (e, xhr, options) {
  var token = $("meta[name='csrf-token']").attr("content");
  xhr.setRequestHeader("X-CSRF-Token", token);
});
