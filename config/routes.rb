Auth::Application.routes.draw do

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "signup#new", :as => "signup"
  post "signup/create" => "signup#create", :as => "signup_create"
  get "signup/success" => "signup#success", :as => "signup_success"
  get "signup/:invitation_token" => "signup#new", :as => "signup_with_token"
  get "pilot" => "invitations#new", :as => "pilot"
  get "pilot/success" => "invitations#success", :as => "pilot_success"
  post "pilotsignup" => "pilot_signups#signup", :as => "pilot_signup"
  get "download" => "pilot_signups#download", :as => "download_ebook"
  get "admin" => "pilot_signups#index", :as => "admin"
#  get "news" => "news#index", :as => "news"
  root :to => "home#index", :as => "root"
  
  resources :users
  resources :sessions
  resources :password_resets
  resources :invitations
  resources :news
  resources :comments
  resources :pilot_signups
  
end
