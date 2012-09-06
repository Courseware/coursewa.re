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

ActiveRecord::Schema.define(:version => 20120906125822) do

  create_table "activities", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.string   "key"
    t.text     "parameters"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "assets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.text     "description"
    t.string   "type"
    t.integer  "assetable_id"
    t.string   "assetable_type"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  add_index "assets", ["assetable_id"], :name => "index_assets_on_assetable_id"
  add_index "assets", ["assetable_type"], :name => "index_assets_on_assetable_type"
  add_index "assets", ["classroom_id"], :name => "index_assets_on_classroom_id"
  add_index "assets", ["user_id"], :name => "index_assets_on_user_id"

  create_table "assignments", :force => true do |t|
    t.string   "title"
    t.string   "slug",         :null => false
    t.text     "content"
    t.text     "quiz"
    t.integer  "lecture_id"
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "assignments", ["classroom_id"], :name => "index_assignments_on_classroom_id"
  add_index "assignments", ["lecture_id"], :name => "index_assignments_on_lecture_id"
  add_index "assignments", ["slug"], :name => "index_assignments_on_slug", :unique => true
  add_index "assignments", ["user_id"], :name => "index_assignments_on_user_id"

  create_table "associations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.string   "type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "associations", ["classroom_id"], :name => "index_associations_on_classroom_id"
  add_index "associations", ["user_id"], :name => "index_associations_on_user_id"

  create_table "classrooms", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "slug",                                :null => false
    t.integer  "owner_id"
    t.integer  "memberships_count",    :default => 0
    t.integer  "collaborations_count", :default => 0
    t.text     "settings"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "classrooms", ["owner_id"], :name => "index_classrooms_on_owner_id"
  add_index "classrooms", ["slug"], :name => "index_classrooms_on_slug", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "lectures", :force => true do |t|
    t.string   "slug",              :null => false
    t.string   "title"
    t.text     "content"
    t.text     "requisite"
    t.integer  "parent_lecture_id"
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "lectures", ["classroom_id"], :name => "index_lectures_on_classroom_id"
  add_index "lectures", ["parent_lecture_id"], :name => "index_lectures_on_parent_lecture_id"
  add_index "lectures", ["slug"], :name => "index_lectures_on_slug", :unique => true
  add_index "lectures", ["user_id"], :name => "index_lectures_on_user_id"

  create_table "plans", :force => true do |t|
    t.integer  "user_id"
    t.integer  "allowed_classrooms"
    t.integer  "allowed_space"
    t.integer  "used_space",            :default => 0
    t.integer  "allowed_collaborators"
    t.date     "expires_in"
    t.string   "slug"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "plans", ["user_id"], :name => "index_plans_on_user_id"

  create_table "syllabuses", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.text     "intro"
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "syllabuses", ["classroom_id"], :name => "index_syllabuses_on_classroom_id"
  add_index "syllabuses", ["user_id"], :name => "index_syllabuses_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                          :null => false
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "role"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "memberships_count",               :default => 0
    t.integer  "collaborations_count",            :default => 0
    t.integer  "created_classrooms_count",        :default => 0
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.integer  "failed_logins_count",             :default => 0
    t.datetime "lock_expires_at"
    t.string   "unlock_token"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "users", ["activation_token"], :name => "index_users_on_activation_token"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["last_logout_at", "last_activity_at"], :name => "index_users_on_last_logout_at_and_last_activity_at"
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

end
