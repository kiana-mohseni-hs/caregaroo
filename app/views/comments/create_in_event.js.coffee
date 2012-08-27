$(<%= "event_comments_count"%>).html(<%= @comments.length %>)
$('#new_event_comment')[0].reset()
$('#event_comments').prepend("<%= escape_javascript(render(:partial => "events/comment", :object => @new_comment)) %>")
