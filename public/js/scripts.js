

jQuery(document).ready(function() {
	
	var validateRegexps = {
		email: /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/,
		generic: /.{4}/ 
	}
            			
	// custom			
	var demoform = $('#demo form')			
	var downloadform = $('#downloadebook form')
	var pilotform = $('#pilot form')			
	var topSignupForm = $('#topSignup form')			
	var bottomSignupForm = $('#bottomSignup form')			
				
	var fnMessage = 'Enter your first name'
	var lnMessage = 'Enter your last name'
	var emailMessage = 'Enter your email address'
	var successMessage = 'Thank you for contacting us, we will respond to your support request as soon as we can. <br/>Your message has been sent successfully.'
	
	$('.top_signup_email').focus(function(){
		if ($(this).val() == emailMessage) {
			$(this).val("")
		}
	});	
	$('.bottom_signup_email').focus(function(){
		if ($(this).val() == emailMessage) {
			$(this).val("")
		}
	});	
	$('.signup_email').focus(function(){
		if ($(this).val() == emailMessage) {
			$(this).val("")
		}
	});		
	$('.signup_first_name').focus(function(){	
		if ($(this).val() == fnMessage) {
			$(this).val("")
		}
	});						
	$('.signup_last_name').focus(function(){	
		if ($(this).val() == lnMessage) {
			$(this).val("")
		}
	});			
	
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
	topSignupForm.submit(pilotSignup)
	bottomSignupForm.submit(pilotSignup)
	
	
	/* preload background image for :hover rules */
	var hoverRe = /:hover/;
	var imgRe = /\(\"?([^\"]+)\"?\)/;
	var preload = [];
	var img
	var url
 	$.each($.makeArray(document.styleSheets), function(){
		var path = this.href ? this.href.replace(/\w+\.css/,"") : ""
		$.each(this.cssRules || this.rules, function(){
			if (hoverRe.test(this.selectorText)) {
				src = this.style.backgroundImage
				if (src) {
					//url = imgRe.exec(src)[1]										
					//img = document.createElement('img')
					//img.src = url.indexOf("http") == 0 ? url : path+url
					//preload.push(img);
				}
			}
		 });
	});

			
	/* fancybox setup code */
            
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
		'overlayColor' : '#000',
		'overlayOpacity':0.85
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

});
