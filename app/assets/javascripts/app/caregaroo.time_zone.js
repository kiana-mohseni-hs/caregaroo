(function(){
if(!window.CG2) window.CG2 = {}

CG2.TimeZone = {
	setSelect: function(selector){ 
		selector = selector || '#user_time_zone'
		var jSelect = $(selector)
		$(function(){
			var off = jstz.determine_timezone()
			off = off && off.timezone && off.timezone.utc_offset
			//off = "-03:00"
			if( off ){
				var matchingOptions = jSelect.find("option:contains('"+off+"'):first")
				if( matchingOptions.size() ){
					jSelect.val( matchingOptions.val() )
				}
			}
		})
	}
}


})()