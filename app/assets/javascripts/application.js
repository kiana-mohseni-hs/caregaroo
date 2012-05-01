// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
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


jQuery(document).ready(function() {
	
	$('#login_email').focus();

	$("a.send_invite").fancybox({
		scrolling:"no",	
		padding:0,
		overlayColor:"#000",
		titlePosition:'outside',
		overlayOpacity:0.7,
		titleShow		: false
	});
	
	$("a.news_comment").click(function(){
		var id = $(this).attr("newsid");
		$("#new_comment_section_"+id).show();
	});
	
	$('input[title!=""]').hint();	
	$('textarea[title!=""]').hint();	
	
	// dropdown
	$(".dropdown dt a").click(function() {
	    $(".dropdown dd ul").toggle();
	});
           
	$(".dropdown dd ul li a").click(function() {
	    var text = $(this).html();
	    $(".dropdown dt a span").html(text);
	    $(".dropdown dd ul").hide();
	    $("#result").html("Selected value is: " + getSelectedValue("sample"));
	});
           
	function getSelectedValue(id) {
	    return $("#" + id).find("dt a span.value").html();
	}

	$(document).bind('click', function(e) {
	    var $clicked = $(e.target);
	    if (! $clicked.parents().hasClass("dropdown"))
	        $(".dropdown dd ul").hide();
	});

	//call the equalize height function
	equalHeight($("div#user_nav, div#container, div#shortcuts"));

	//equalize funciton
	function equalHeight(group) {
		tallest = 0;
		group.each(function() {
			thisHeight = $(this).height();
			if(thisHeight > tallest) {
				tallest = thisHeight;
			}
     });
     group.height(tallest);
	}

});