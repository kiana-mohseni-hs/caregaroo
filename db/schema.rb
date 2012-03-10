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

ActiveRecord::Schema.define(:version => 20120307082057) do

  create_table "comments", :force => true do |t|
    t.string   "name"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id"
    t.integer  "user_id"
  end

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
  end

  create_table "messages", :force => true do |t|
    t.integer  "folder_id"
    t.integer  "sender_id"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "networks", :force => true do |t|
    t.string   "network_name"
    t.string   "network_for_who"
    t.integer  "host_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pilot_signups", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "signup_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "name"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "network_id"
    t.integer  "user_id"
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
    t.string   "network_relationship"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "network_id"
  end

end
