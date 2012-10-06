// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require jquery.timepicker.js
//= require jquery.fancybox-1.3.4.pack.js
//= require jquery.purr.js
//= require jquery.hint-with-password.js
//= require jquery.autosize-min.js
//= require fancybox
//= require_tree ./app

var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-23336907-1']);
_gaq.push(['_trackPageview']);

(function() {
	var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
	ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
	var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();

try{
    function yt_callback(category,action,label,value){
    	_gaq.push(['_trackEvent',category,action,label,value]);
    }
    var ytTracker = new YoutubeTracker(false, yt_callback, true);
} catch(e){}


$(function() {
	
	// profile avatar full image
	$('.large_avatar').fancybox({
		scrolling:"no",	
		padding:0,
		overlayColor:"#000",
		titlePosition:'outside',
		overlayOpacity:0.7,
		titleShow		: false
	});
	
	// profile upload avatar
	$('#preview').live('change', function(event){
		$('#preview-photo').html(this.value);
  	});
	
	// right panel shortcut
	$('#invite_shortcut').click(function(event){
		_gaq.push(['_trackEvent', 'Links', 'Invite Members', 'Invite Members']);
        document.location = '/invite';
  	});
  	
	$('#help_shortcut').click(function(event){
		_gaq.push(['_trackEvent', 'Links', 'Need Help', 'Need Help']);
        window.open('https://caregaroo.zendesk.com/forums');
  	}); 
  	
	$('#questions_shortcut').click(function(event){
		_gaq.push(['_trackEvent', 'Links', 'Email Us', 'Email Us']);
       window.open('https://caregaroo.zendesk.com/anonymous_requests/new');
  	});
    
    // input box focus on page load
	$('#session_email').focus();
	$('#network_network_name').focus();
	$('#invitation_email').focus();
	$('#signup_email').focus();

	// news stream post and comments auto textarea 
	$('textarea').autosize();
	
	// news stream show new comment
	$("span.news_comment").click(function(){
		var id = $(this).attr("post-id");
		$("#new_comment_section_"+id).show();
		$("#new_comment_section_"+id+" textarea").focus();
	});
	
	$('input[title!=""]').hint();	
	$('textarea[title!=""]').hint();	
	
	// top nav dropdown
	$(".dropdown dt a").click(function() {
	    $(".dropdown dd ul").toggle();
	    $(".dropdown dt .dt_arrow_bg").toggle();
	});
           
	$(".dropdown dd ul li a").click(function() {
	    var text = $(this).html();
	    $(".dropdown dt a span").html(text);
	    $(".dropdown dd ul").hide();
	     $(".dropdown dt .dt_arrow_bg").hide();
	    $("#result").html("Selected value is: " + getSelectedValue("sample"));
	});
           
	function getSelectedValue(id) {
	    return $("#" + id).find("dt a span.value").html();
	}

	$(document).bind('click', function(e) {
	    var $clicked = $(e.target);
	    if (! $clicked.parents().hasClass("dropdown"))
	    {
	        $(".dropdown dd ul").hide();
	        $(".dropdown dt .dt_arrow_bg").hide();
	    }
	});

	// set the equalize height in layout
	window.equalHeight = function(group) {
		tallest = $(document).height();
		group.each(function() {
			thisHeight = $(this).height();
			if(thisHeight > tallest) {
				tallest = thisHeight;
			}
		});
     	group.height(tallest).css({cursor:"auto"});
	}
	equalHeight($("div#user_nav, div#container, div#shortcuts"));

	//enable submit button with a TOS checkbox
	$('#tos').click(function () {
		if (this.checked){
			$('#create_btn').removeAttr('disabled');
			$('#signup_next_btn').removeAttr('disabled');
			$('#create_btn').attr('class', 'form_button');
			$('#signup_next_btn').attr('class', 'form_button');
		
		} else {
			$('#create_btn').attr('disabled', 'disabled');
			$('#signup_next_btn').attr('disabled', 'disabled');
			$('#create_btn').attr('class', 'form_button_disabled');
			$('#signup_next_btn').attr('class', 'form_button_disabled');
		};
	});
	
	// member set coordinator
	$('.coordinator').click(function() {
		$.ajax({
	    	url: $(this).data('href'),
	    	type: 'PUT',
	    	data: {checked:$(this).is(':checked')},
	    	dataType: 'html',
	    	success: function(data, textStatus, jqXHR) {
	      		$( data ).purr({
					usingTransparentPNG: true
				});
				return false;
	    	}
		});
	})
});