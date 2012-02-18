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

ActiveRecord::Schema.define(:version => 20120213165438) do

  create_table "customers_view", :id => false, :force => true do |t|
    t.integer  "id",                               :default => 0, :null => false
    t.integer  "UID",                                             :null => false
    t.string   "screen_name",       :limit => 50
    t.string   "name",              :limit => 50
    t.integer  "province"
    t.string   "province_name",     :limit => 100
    t.integer  "city"
    t.string   "city_name",         :limit => 100
    t.string   "location",          :limit => 50
    t.string   "profile_image_url", :limit => 100
    t.string   "domain",            :limit => 50
    t.string   "gender",            :limit => 50
    t.integer  "followers_count"
    t.integer  "friends_count"
    t.integer  "statuses_count"
    t.integer  "favourites_count"
    t.integer  "user_id",                                         :null => false
    t.datetime "created_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "display_messages", :force => true do |t|
    t.integer  "WID",                       :null => false
    t.string   "wtext"
    t.datetime "created_w"
    t.string   "source",     :limit => 100
    t.integer  "user_id",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monitor_messages", :force => true do |t|
    t.integer  "WID",            :null => false
    t.integer  "reposts_count"
    t.integer  "comments_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "province_cities", :force => true do |t|
    t.string   "NodeClass",  :limit => 50
    t.string   "Code",       :limit => 50
    t.string   "ParentCode", :limit => 50
    t.string   "Name",       :limit => 100
    t.string   "Name_En",    :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rule_messages", :force => true do |t|
    t.integer  "user_id",                   :null => false
    t.string   "rulename",   :limit => 100, :null => false
    t.string   "keyword"
    t.string   "username"
    t.integer  "filterori"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "upload_messages", :force => true do |t|
    t.string   "message"
    t.string   "image"
    t.datetime "uploadtime"
    t.string   "username"
    t.boolean  "isselected"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_infos", :force => true do |t|
    t.integer  "user_id",                        :null => false
    t.string   "nick_name",       :limit => 50,  :null => false
    t.string   "real_name",       :limit => 50
    t.integer  "province"
    t.integer  "city"
    t.integer  "gender"
    t.integer  "name_option"
    t.integer  "birthday_option"
    t.string   "blog",            :limit => 100
    t.integer  "blog_option"
    t.string   "email",           :limit => 100
    t.integer  "email_option"
    t.string   "qq",              :limit => 100
    t.integer  "qq_option"
    t.string   "msn",             :limit => 100
    t.integer  "msn_option"
    t.string   "mydesc"
    t.integer  "Date_Day"
    t.integer  "Data_Month"
    t.integer  "Data_Year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "userkeys", :force => true do |t|
    t.string   "mail_user",  :limit => 100, :null => false
    t.string   "weibo_firm", :limit => 50,  :null => false
    t.string   "key1",       :limit => 50,  :null => false
    t.string   "key2",       :limit => 50,  :null => false
    t.integer  "user_id",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "username_selects", :force => true do |t|
    t.integer  "UID",                              :null => false
    t.string   "screen_name",       :limit => 50
    t.string   "name",              :limit => 50
    t.integer  "province"
    t.integer  "city"
    t.string   "location",          :limit => 50
    t.string   "url",               :limit => 50
    t.string   "profile_image_url", :limit => 100
    t.string   "domain",            :limit => 50
    t.string   "gender",            :limit => 50
    t.datetime "created_user"
    t.string   "geo_enabled",       :limit => 10
    t.integer  "followers_count"
    t.integer  "friends_count"
    t.integer  "statuses_count"
    t.integer  "favourites_count"
    t.integer  "user_id",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
