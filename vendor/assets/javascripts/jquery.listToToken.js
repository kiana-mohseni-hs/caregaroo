/**
 * jquery.listToToken.js
 * Copyleft (c) Fabiano Pereira Soriani
 * The style and ev handling is up to you, we just slice and dice! Compatible up to IE7 unless someone relevant states otherwise.
 * 
 * @author @flockonus
 * @projectDescription	Moves one item from one div to the other, how it happens is all up to you.
 * @version 0.0.1
 * 
 * @requires jquery.js (tested with 1.8x)
 * 
 * @param param.from 				object - see example
 * @param param.to  				object - see example
 														default: 500
 *	@param removeTimer  				int - Timeout, in miliseconds, before notice is removed once it is the top non-sticky notice in the list
 														default: 4000
 *	@param isSticky 						bool - Whether the notice should fade out on its own or wait to be manually closed
 														default: false
 *	@param usingTransparentPNG 	bool - Whether or not the notice is using transparent .png images in its styling
 														default: false
 */

( function( $ ) {
/*
$(document).ready(function(){
	var listToToken = $.listToToken({
		from: {
			selector: "#new_news_wrapper .all_recipients div",
			onClick: function(jElem, jTo, ev){
				jTo.children('.time_text:visible').hide()
				jElem.slideUp();
				var newLing = $( "<div/>",{
					"class": "tokenizer",
					'data-user-id': jElem.data('userId'),
					'style': 'display:none',
					html: jElem.html(),
				})
				jTo.append(newLing)
				newLing.slideDown('slow')
			},
		},
		to: {
			wrapSelector: "#new_news_wrapper .current_recipients",
			tokenSelector: "#new_news_wrapper .current_recipients .tokenizer",
			onClick: function(jToken, jFrom, ev, jTo){
				var uid = jToken.data('userId')
				jToken.slideUp(function(){
					$(this).remove()
				})
				jFrom.each(function(){
					if( $(this).data('userId') == uid ){
						$(this).slideDown();
					}
				})
				setTimeout(function(){
					if( jTo.children('.tokenizer:visible').size() < 1 ){
						jTo.find('.time_text').fadeIn()
					}
				},550)
			},
		},
		init: function(jFrom,jTo){
			jTo.find('.tokenizer').remove()
			jFrom.each(function(){
				if( $(this).data('default') ){
					$(this).click()
				}
			})
		}
	});

	listToToken.init();

	// XXX
	$('#news_update_button').click(function(ev){
		ev.preventDefault()
		listToToken.init()
	})
})

	$.listToToken = function ( param ) {
		var from = param.from
		var to = param.to
		// store the destination
		var jTo = $(to.wrapSelector)

		// bind click event so clicked elements go to the list
		$(from.selector).live('click', function(ev){
			from.onClick($(ev.currentTarget), jTo, ev)
		})
		$(to.tokenSelector).live('click', function(ev){
			to.onClick($(ev.currentTarget), $(from.selector), ev, jTo)
		})

		return {
			init: function(){
				if(param.init)
					param.init($(from.selector),jTo)
			}
		}
	};
*/
})( jQuery );

