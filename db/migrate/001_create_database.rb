class CreateDatabase < ActiveRecord::Migration
  def self.up
    begin
    
      create_table "comments" do |t|
        t.string   "name"
        t.text     "content"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.integer  "post_id"
        t.integer  "user_id"
      end

      create_table "folders" do |t|
        t.integer  "parent_id"
        t.string   "display_name"
        t.string   "description"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      create_table "invitations" do |t|
        t.string   "first_name"
        t.string   "last_name"
        t.string   "email"
        t.string   "token"
        t.datetime "sent_at"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.integer  "send_id"
      end

      create_table "messages" do |t|
        t.integer  "folder_id"
        t.integer  "sender_id"
        t.string   "body"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      create_table "networks" do |t|
        t.string   "network_name"
        t.string   "network_for_who"
        t.integer  "host_user_id"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      create_table "pilot_signups" do |t|
        t.string   "email"
        t.string   "first_name"
        t.string   "last_name"
        t.string   "signup_type"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      create_table "posts" do |t|
        t.string   "name"
        t.text     "content"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.integer  "network_id"
      end

      create_table "profiles" do |t|
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

      create_table "recipients" do |t|
        t.integer  "user_id"
        t.integer  "message_id"
        t.boolean  "is_read"
        t.boolean  "is_deleted"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      create_table "users" do |t|
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
      end

    rescue
      puts "Skip first migration"
    end
  end

  def self.down
    drop_table "comments"
    drop_table "folders"
    drop_table "invitations"
    drop_table "messages"
    drop_table "networks"
    drop_table "pilot_signups"
    drop_table "posts"
    drop_table "profiles"
    drop_table "recipients"
    drop_table "users"
  end
end