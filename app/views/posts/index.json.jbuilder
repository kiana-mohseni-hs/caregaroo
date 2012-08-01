json.array!(@posts) do |json, post|
  json.date post.updated_at.strftime("%A, %-d %B %Y at %I:%M %P")
  json.author post.user_id == current_user.id
  json.(post, :id, :content)
  json.user do |json|
    json.first_name post.user.first_name
    json.thumb_url post.user.avatar.thumb.url
  end
  json.comments post.comments do |json, comment|
    json.(comment, :id, :content, :user_id)
    json.date time_ago_in_words(comment.updated_at)
    json.author comment.user_id == current_user.id
    json.user do |json|
      json.first_name comment.user.first_name
      json.thumb_url comment.user.avatar.thumb.url
    end
  end
end
