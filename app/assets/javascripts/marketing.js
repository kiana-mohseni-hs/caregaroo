//= require jquery
//= require jquery_ujs

jQuery(document).ready(function() {
	
	var validateRegexps = {
		email: /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/,
		generic: /.{4}/ 
	}
            			
	// custom			
	var demoform = $('#demo form')			
	var downloadform = $('#downloadebook form')
	var pilotform = $('#pilot form')			
				
	var fnMessage = 'Enter your first name'
	var lnMessage = 'Enter your last name'
	var emailMessage = 'Enter your email address'
	var successMessage = 'Thank you for contacting us, we will respond to your support request as soon as we can. <br/>Your message has been sent successfully.'
	
	$('input[title!=""]').hint();	
	$('textarea[title!=""]').hint();
	
	function pilotSignup() {
		var email = $(this).find('input[name="pilot_signup[email]"]')
		var error = $(this).find('div[class="error"]')
		if (validateRegexps["email"].test(email.val())) {
         // valid mail
			error.hide()
			return true    
		} else {
			error.show()
		}
		
		return false
	}
	
	demoform.submit(pilotSignup)
	downloadform.submit(pilotSignup)
	pilotform.submit(pilotSignup)
            
	$("a.custom").fancybox({
		scrolling:"no",
		padding:0,
		overlayColor:"#000",
		titlePosition:'outside',
		overlayOpacity:0.7,
		'titleShow'		: false,
//		'onComplete' : function(){ $('#downloadebook :input:visible:enabled:first').focus()},
		'onClosed'		: function() {
			$('.signup_email').val(emailMessage)
			$('.signup_first_name').val(fnMessage)
			$('.signup_last_name').val(lnMessage)
			$('.error').hide()
		}
	});
	
	//features images
	$("a.single_image").fancybox({
		overlayColor : '#000',
		overlayOpacity:0.85
	});
    
 	//showcase swf
 	$("a.iframe").fancybox({
            'hideOnContentClick': false,
            'width': 960,
            'height':600,
            'overlayColor' : '#000',
            'overlayOpacity':0.9 
	});
    
   //for contact form
   $("a#inline").fancybox({
            'hideOnContentClick': false,
            'scrolling':'no',
            'padding':0,
            'overlayColor' : '#000',
            'overlayOpacity':0.9         
   });

    /* end fancybox setup code */

  	
  	$('#help_top_nav').click(function(event){
		//_gaq.push(['_trackEvent', 'Links', 'Need Help', 'Need Help']);
        window.open('https://caregaroo.zendesk.com/forums');
  	});
});
