Auth::Application.routes.draw do

  # pilot app
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "register" => "register#index", :as => "register"
  post "register" => "register#create", :as => "register"
  get "profile" => "profile#index", :as => "profile"
  get "profile/basic" => "profile#basic", :as => "basic_profile"
  post "profile/basic" => "profile#update_basic", :as => "update_basic_profile"
  get "profile/password" => "profile#password", :as => "password_profile"
  post "profile/password" => "profile#update_password", :as => "update_password_profile"
  get "profile/notifications" => "profile#notifications", :as => "notifications_profile"
  get "news" => "posts#index", :as => "news"

# post "signup/create" => "signup#create", :as => "signup_create"
#  get "signup/success" => "signup#success", :as => "signup_success"
#  get "signup/:invitation_token" => "signup#new", :as => "signup_with_token"
#  get "pilot" => "invitations#new", :as => "pilot"
#  get "pilot/success" => "invitations#success", :as => "pilot_success"
#  post "pilotsignup" => "pilot_signups#signup", :as => "pilot_signup" 

  # pilot www homepage 
  post "pilot_signups/:id" => "pilot_signups#destroy", :as => "signup_delete"
  get "download/ebook" => "download#ebook", :as => "download_ebook"
  get "download/faq" => "download#faq", :as => "download_faq"
  get "admin" => "pilot_signups#index", :as => "admin"
  post "signup" => "register#signup", :as => "signup"
  root :to => "home#index", :as => "root"
  
#  resources :users
  resources :sessions
  resources :password_resets
#  resources :invitations
  resources :posts
  resources :comments
  resources :pilot_signups
  
end
