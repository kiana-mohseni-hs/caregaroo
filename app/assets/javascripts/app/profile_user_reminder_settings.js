$(document).ready(function(){
	$("#new_user_reminder_setting").hide();
	$("#add_user_reminder").click(function(e){
		e.preventDefault();
		$("#new_user_reminder_setting").show();
	});
});
