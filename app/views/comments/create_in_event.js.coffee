$(<%= "event_comments_count"%>).html(<%= @comments.length %>)
$('#new_post_comment')[0].reset()
# $('.commentstitle').after("<li>testing adding</li>")