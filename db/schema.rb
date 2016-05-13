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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160512205412) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "code_reviews", force: true do |t|
    t.text     "context"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.boolean  "deleted",    default: false
    t.string   "url"
    t.string   "commit_sha"
    t.string   "repo"
    t.string   "repo_owner"
    t.string   "branch"
    t.boolean  "is_private", default: false
    t.integer  "repo_id"
  end

  create_table "comment_feeds", force: true do |t|
    t.string   "repository"
    t.integer  "user_id"
    t.string   "url_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "github_entity"
    t.boolean  "deleted",       default: false
  end

  create_table "comments", force: true do |t|
    t.integer  "code_review_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "github_id"
  end

  create_table "comments_sentiments", id: false, force: true do |t|
    t.integer "comment_id",   null: false
    t.integer "sentiment_id", null: false
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.boolean  "private_scope", default: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "leads", force: true do |t|
    t.string   "email"
    t.string   "username"
    t.string   "source"
    t.hstore   "original_blob"
    t.boolean  "registered",    default: false
    t.boolean  "opt_out",       default: false
    t.integer  "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "user_blob"
    t.hstore   "repo_blob"
  end

  create_table "notification_channels", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notification_channels_users", force: true do |t|
    t.integer "notification_channel_id"
    t.integer "user_id"
  end

  create_table "offers", force: true do |t|
    t.integer  "code_review_id"
    t.integer  "user_id"
    t.string   "aasm_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "fund_a_coder"
    t.integer  "value"
    t.string   "note"
    t.boolean  "karma"
  end

  create_table "payments", force: true do |t|
    t.integer  "offer_id"
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.string   "description"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sentiments", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile_pic"
    t.string   "github_profile"
    t.boolean  "confirmed"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "voteable_id"
    t.string   "voteable_type"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "context"
    t.integer  "sentiment_id"
  end

  create_table "wallets", force: true do |t|
    t.string   "stripe_uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_refresh_token"
    t.string   "stripe_publishable_key"
    t.string   "stripe_scope"
    t.string   "stripe_access_token"
    t.string   "stripe_cc_token"
    t.string   "stripe_customer_id"
    t.string   "stripe_card_id"
  end

end
