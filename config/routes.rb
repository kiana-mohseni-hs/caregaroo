Auth::Application.routes.draw do

  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
  get "calendar/show"

  # app routes
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#login", :as => "login"
  get "register" => "register#index", :as => "register"
  post "register" => "register#create", :as => "register"
  get "register/success" => "register#success", :as => "register_success"
  get "profile" => "profile#info", :as => "profile"
  get "profile/edit" => "profile#edit_info", :as => "edit_info_profile"
  get "profile/:user_id" => "profile#info", :as => "user_info_profile"
  post "profile" => "profile#update_info", :as => "update_info_profile"
  get "news" => "posts#index", :as => "news"
  get "news/:post_id/comments" => "posts#comments", :as => "post_commments"
  get "news/:post_id" => "posts#full_post", :as => "post"
  delete "news/:post_id" => "posts#destroy", :as => "post_delete"
  get "comment/:comment_id" => "comments#full_comment", :as => "comment"
  delete "comment/:comment_id" => "comments#destroy", :as => "comment"
  get "members" => "members#index", :as => "members"
  put "members/:user_id" => "members#update", :as => "members_update"
  delete "members/:user_id" => "members#delete", :as => "members_delete"
  get "invite" => "invitations#index", :as => "invite"
  get "invite/success" => "invitations#success", :as => "success_invitation"
  post "invite/send" => "invitations#create", :as => "send_invitation"
  post "messages/reply" => "messages#reply", :as => "reply_message"
  get "unsubscribe" => "notifications#unsubscribe", :as => "unsubscribe"

  post "signup/create" => "signup#create", :as => "signup_create"
  get "signup/success" => "signup#success", :as => "signup_success"
  get "signup/:invitation_token" => "signup#new", :as => "signup_with_token"

  # marketing routes
  post "pilot_signups/:id" => "pilot_signups#destroy", :as => "signup_delete"
  get "download/ebook" => "download#ebook", :as => "download_ebook"
  get "download/faq" => "download#faq", :as => "download_faq"
  get "admin" => "pilot_signups#index", :as => "admin"
  post "signup" => "register#signup", :as => "signup"
  match "product" => "home#product"
  
  root :to => "home#index", :as => "root"
  
  resources :sessions
  resources :password_resets
  resources :messages
  resources :posts
  resources :comments
  resources :pilot_signups
  resources :events
  
  mount Resque::Server, :at => "/resque"
end
