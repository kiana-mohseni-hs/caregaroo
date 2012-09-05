$(<%= "event_comment_#{@comment.id}"%>).slideUp()
$(<%= "event_comments_count"%>).html(<%= @post.comments.length %>)
