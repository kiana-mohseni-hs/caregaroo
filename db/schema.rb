# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121120183842) do

  create_table "affiliations", :force => true do |t|
    t.string   "relationship"
    t.integer  "network_id"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "role"
  end

  add_index "affiliations", ["network_id"], :name => "index_affiliations_on_network_id"
  add_index "affiliations", ["user_id"], :name => "index_affiliations_on_user_id"

  create_table "comments", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id"
    t.integer  "user_id"
    t.integer  "network_id"
  end

  create_table "event_types", :force => true do |t|
    t.string "name"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "network_id"
    t.integer  "event_type_id",  :default => 1
    t.string   "location"
    t.text     "description"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "post_id"
    t.boolean  "canceled",       :default => false
    t.integer  "canceled_by_id"
  end

  create_table "events_users", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "user_id"
  end

  add_index "events_users", ["event_id", "user_id"], :name => "index_events_users_on_event_id_and_user_id"

  create_table "folders", :force => true do |t|
    t.integer  "parent_id"
    t.string   "display_name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "token"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "send_id"
    t.integer  "network_id"
  end

  create_table "messages", :force => true do |t|
    t.integer  "folder_id"
    t.integer  "sender_id"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "networks", :force => true do |t|
    t.string   "name"
    t.string   "network_for_who"
    t.integer  "host_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar"
    t.integer  "users_count",     :default => 0, :null => false
    t.integer  "posts_count",     :default => 0, :null => false
    t.integer  "events_count",    :default => 0, :null => false
  end

  create_table "notifications", :force => true do |t|
    t.boolean  "announcement"
    t.boolean  "post_update"
    t.boolean  "response_post"
    t.boolean  "calendar_task_added"
    t.boolean  "member_volunteer_task"
    t.boolean  "receive_thanks"
    t.boolean  "member_receives_thanks"
    t.integer  "user_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "pilot_signups", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "signup_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_recipients", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "network_id"
    t.integer  "user_id"
    t.string   "photo"
  end

  create_table "profiles", :force => true do |t|
    t.string   "bio"
    t.string   "location"
    t.string   "significant_other"
    t.string   "kids_name"
    t.date     "birthdate"
    t.string   "expertise"
    t.string   "can_help_with"
    t.string   "phone_work"
    t.string   "phone_mobile"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_home"
    t.string   "phone_work_ext"
  end

  create_table "recipients", :force => true do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.boolean  "is_read"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "network_id"
    t.string   "avatar"
    t.string   "time_zone",              :limit => 32, :default => "Pacific Time (US & Canada)"
    t.boolean  "system_admin",                         :default => false,                        :null => false
  end

end
