json.array!(@posts) do |json, post|
  json.date post.updated_at.strftime("%A, %-d %B %Y at %I:%M %P")
  json.commentscount post.comments.count
  json.(post, :id, :content)
  json.user do |json|
    json.first_name post.user.first_name
    json.thumb_url post.user.avatar.thumb.url
  end
end
