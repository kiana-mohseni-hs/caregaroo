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
})( jQuery );

