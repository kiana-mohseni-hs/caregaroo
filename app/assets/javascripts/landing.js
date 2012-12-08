// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require modernizr

var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-23336907-1']);
_gaq.push(['_setDomainName', 'caregaroo.com']);
_gaq.push(['_trackPageview']);

(function() {
	var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
	ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
	var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();

$(document).ready(function() {

	if (!Modernizr.input.placeholder) {

		$('[placeholder]').focus(function() {
		  
		  var input = $(this);
		  if (input.val() == input.attr('placeholder')) {
				input.val('');
				input.removeClass('placeholder');
		  }

		}).blur(function() {
		  
		  var input = $(this);
		  if (input.val() == '' || input.val() == input.attr('placeholder')) {
				input.addClass('placeholder');
				input.val(input.attr('placeholder'));
		  }

		}).blur();

		$('[placeholder]').parents('form').submit(function() {
		  $(this).find('[placeholder]').each(function() {
				var input = $(this);
				if (input.val() == input.attr('placeholder')) {
				  input.val('');
				}
		  });
		});

	}

	function targetMyFormOut(ev){
		var ja = $(this);
		var email = ja.siblings('[name=email]').val();
		debugger
		ja.attr('href', ja.attr('href')+encodeURIComponent(email) )
	}

	$('.email_form a').one('click',targetMyFormOut);

});