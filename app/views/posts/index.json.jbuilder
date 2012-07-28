json.array!(@posts) do |json, post|
  json.date post.updated_at.strftime("%A, %-d %B %Y at %I:%M %p")
  json.(post, :id, :content)
  json.user do |json|
    json.first_name post.user.first_name
    json.thumb_url post.user.avatar.thumb.url
  end
end
