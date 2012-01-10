/*

    Theme Name: promo
    Description: promotional landing page theme for themeforest.net
    Theme Owner: pixelentity
    File: Javascript file
    Designer : Donagh O'Keeffe aka iamdok
    Slicer/Coder : Donagh O'Keeffe aka iamdok & Fabio Ciaro aka bitfade
    Web:    http://www.iamdok.com
            http://bitfade.com
            http://themeforest.net/user/pixelentity
        
*/

jQuery(document).ready(function() {
	
	var validateRegexps = {
		email: /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/,
		generic: /.{4}/ 
	}
            
	/* contact form related code */
	function validate() {
           
		var isOk = true
           
		contactForm.find(".required").each(function () {
    
      	var re = validateRegexps[this.name]
         var value = $(this).val()
            
         if (!re) re = validateRegexps['generic']
    
         if (!re.test(value)) {
                 $(this).addClass("error")
                 isOk = false
         } else {
                 $(this).removeClass("error")
        }
     })
    
     return isOk
    }
            
    function validateAndSend() {
			if (validate()) {
				$.post("contact.php", contactForm.serialize(), function(data) {
					$("#contact #message").html(data)
               $("#contact form").hide();
               $("#contact #result").fadeIn();
				});
              
      }
      return false
	}
      
	function clearForm() {
		contactForm.get(0).reset();
      $("#contact #result").hide();
      $("#contact form").fadeIn();
           
   }
   /* end contact form code */
   
   /* newsletter code */
   function newsletter(send) {
		var subscribe = newsletterForm.find('input:checked').length == 0
		newsletterForm.find('input[type="submit"]').val(subscribe ? "Sign Up" : "Unsubscribe")
           
		var email = newsletterForm.find('input[name="email"]')
		if (email.val() == defaultMessage) {
			email.val("")
		} else if(validateRegexps["email"].test(email.val())) {
         // valid mail
         email.removeClass("error")
         if (send) {
                 $.post("newsletter.php", newsletterForm.serialize(), function(data) {
                         defaultMessage = data
                         email.val(defaultMessage)
                 });
                 email.val("SENDING REQUEST")
         }
         
		} else {
         // invalid mail
         email.addClass("error")
 		}
       
		return false
   }
      
	function signUp() {
		newsletter(false)
		return true
	}
    
	function signUpAndSend() {
		return newsletter(true)
	}
         
	/* end newsletter code */
    
   var contactForm = $('#contact form')
   var newsletterForm = $('#newsletter form')
   var defaultMessage = newsletterForm.find('input[name="email"]').focus(signUp).val()
            
   $('#contact #submit').click(validateAndSend)
   $('#contact #clearForm').click(clearForm)
   contactForm.change(validate)
    
   newsletterForm.change(signUp)
   newsletterForm.submit(signUpAndSend)
			
	// custom			
	var demoform = $('#demo form')			
	var downloadform = $('#downloadebook form')
	var pilotform = $('#pilot form')			
				
	var fnMessage = 'Enter your first name'
	var lnMessage = 'Enter your last name'
	var emailMessage = 'Enter your email address'
	var successMessage = 'Thank you for contacting us, we will respond to your support request as soon as we can. <br/>Your message has been sent successfully.'
	
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
            
	$("a#custom").fancybox({
		scrolling:"no",
		padding:0,
		overlayColor:"#000",
		titlePosition:'outside',
		overlayOpacity:0.9,
		'titleShow'		: false,
		'onClosed'		: function() {
			$('.signup_email').val(emailMessage)
			$('.signup_first_name').val(fnMessage)
			$('.signup_last_name').val(lnMessage)
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