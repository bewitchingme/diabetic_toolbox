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

ActiveRecord::Schema.define(version: 20150926051642) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "diabetic_toolbox_achievements", force: :cascade do |t|
    t.integer  "member_id"
    t.string   "name"
    t.integer  "points"
    t.integer  "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "diabetic_toolbox_achievements", ["member_id"], name: "index_diabetic_toolbox_achievements_on_member_id", using: :btree

  create_table "diabetic_toolbox_ingredients", force: :cascade do |t|
    t.integer  "recipe_id"
    t.string   "name"
    t.float    "volume"
    t.integer  "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "diabetic_toolbox_ingredients", ["recipe_id"], name: "index_diabetic_toolbox_ingredients_on_recipe_id", using: :btree

  create_table "diabetic_toolbox_members", force: :cascade do |t|
    t.string   "first_name",               default: "",    null: false
    t.string   "last_name",                default: "",    null: false
    t.string   "username",                 default: "",    null: false
    t.string   "slug",                     default: "",    null: false
    t.string   "email",                    default: "",    null: false
    t.string   "encrypted_password",       default: "",    null: false
    t.string   "encryption_salt",          default: "",    null: false
    t.string   "session_token"
    t.integer  "recipes_count",            default: 0,     null: false
    t.integer  "achievements_count",       default: 0,     null: false
    t.integer  "settings_count",           default: 0,     null: false
    t.integer  "readings_count",           default: 0,     null: false
    t.date     "dob"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remembered_at"
    t.string   "remembrance_token"
    t.datetime "current_session_began_at"
    t.string   "current_session_ip"
    t.datetime "last_session_began_at"
    t.string   "last_session_ip"
    t.string   "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts"
    t.string   "unlock_token"
    t.datetime "last_locked_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "gender"
    t.boolean  "accepted_tos",             default: false, null: false
    t.string   "time_zone",                default: "UTC", null: false
    t.integer  "locale",                   default: 0,     null: false
  end

  add_index "diabetic_toolbox_members", ["confirmation_token"], name: "index_diabetic_toolbox_members_on_confirmation_token", unique: true, using: :btree
  add_index "diabetic_toolbox_members", ["email"], name: "index_diabetic_toolbox_members_on_email", unique: true, using: :btree
  add_index "diabetic_toolbox_members", ["remembrance_token"], name: "index_diabetic_toolbox_members_on_remembrance_token", unique: true, using: :btree
  add_index "diabetic_toolbox_members", ["reset_password_token"], name: "index_diabetic_toolbox_members_on_reset_password_token", unique: true, using: :btree
  add_index "diabetic_toolbox_members", ["session_token"], name: "index_diabetic_toolbox_members_on_session_token", unique: true, using: :btree
  add_index "diabetic_toolbox_members", ["slug"], name: "index_diabetic_toolbox_members_on_slug", unique: true, using: :btree
  add_index "diabetic_toolbox_members", ["unlock_token"], name: "index_diabetic_toolbox_members_on_unlock_token", unique: true, using: :btree

  create_table "diabetic_toolbox_nutritional_facts", force: :cascade do |t|
    t.integer  "recipe_id"
    t.string   "nutrient"
    t.float    "quantity"
    t.boolean  "verified",   default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "diabetic_toolbox_nutritional_facts", ["recipe_id"], name: "index_diabetic_toolbox_nutritional_facts_on_recipe_id", using: :btree

  create_table "diabetic_toolbox_readings", force: :cascade do |t|
    t.integer  "member_id"
    t.float    "glucometer_value"
    t.datetime "test_time"
    t.integer  "meal"
    t.integer  "intake"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "diabetic_toolbox_readings", ["glucometer_value"], name: "index_diabetic_toolbox_readings_on_glucometer_value", using: :btree
  add_index "diabetic_toolbox_readings", ["meal"], name: "index_diabetic_toolbox_readings_on_meal", using: :btree
  add_index "diabetic_toolbox_readings", ["member_id"], name: "index_diabetic_toolbox_readings_on_member_id", using: :btree
  add_index "diabetic_toolbox_readings", ["test_time"], name: "index_diabetic_toolbox_readings_on_test_time", using: :btree

  create_table "diabetic_toolbox_recipes", force: :cascade do |t|
    t.integer  "member_id"
    t.string   "name"
    t.integer  "servings"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "published"
    t.integer  "steps_count",             default: 0, null: false
    t.integer  "ingredients_count",       default: 0, null: false
    t.integer  "nutritional_facts_count", default: 0, null: false
  end

  add_index "diabetic_toolbox_recipes", ["member_id"], name: "index_diabetic_toolbox_recipes_on_member_id", using: :btree
  add_index "diabetic_toolbox_recipes", ["published"], name: "index_diabetic_toolbox_recipes_on_published", using: :btree
  add_index "diabetic_toolbox_recipes", ["servings"], name: "index_diabetic_toolbox_recipes_on_servings", using: :btree

  create_table "diabetic_toolbox_report_configurations", force: :cascade do |t|
    t.integer  "member_id"
    t.string   "name"
    t.integer  "period"
    t.date     "from"
    t.date     "to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "diabetic_toolbox_report_configurations", ["member_id"], name: "index_diabetic_toolbox_report_configurations_on_member_id", using: :btree

  create_table "diabetic_toolbox_reports", force: :cascade do |t|
    t.integer  "member_id"
    t.string   "name"
    t.datetime "coverage_start"
    t.datetime "coverage_end"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "report_document_file_name"
    t.string   "report_document_content_type"
    t.integer  "report_document_file_size"
    t.datetime "report_document_updated_at"
  end

  add_index "diabetic_toolbox_reports", ["member_id"], name: "index_diabetic_toolbox_reports_on_member_id", using: :btree

  create_table "diabetic_toolbox_settings", force: :cascade do |t|
    t.integer  "member_id"
    t.integer  "glucometer_measure_type"
    t.integer  "intake_measure_type"
    t.float    "intake_ratio"
    t.float    "correction_begins_at"
    t.float    "increments_per"
    t.integer  "ll_units_per_day"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "diabetic_toolbox_settings", ["glucometer_measure_type"], name: "index_diabetic_toolbox_settings_on_glucometer_measure_type", using: :btree
  add_index "diabetic_toolbox_settings", ["intake_measure_type"], name: "index_diabetic_toolbox_settings_on_intake_measure_type", using: :btree
  add_index "diabetic_toolbox_settings", ["member_id"], name: "index_diabetic_toolbox_settings_on_member_id", using: :btree

  create_table "diabetic_toolbox_steps", force: :cascade do |t|
    t.integer  "recipe_id"
    t.string   "description"
    t.integer  "order"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "diabetic_toolbox_steps", ["recipe_id"], name: "index_diabetic_toolbox_steps_on_recipe_id", using: :btree

  create_table "diabetic_toolbox_votes", force: :cascade do |t|
    t.boolean  "vote",          default: false, null: false
    t.integer  "voteable_id",                   null: false
    t.string   "voteable_type",                 null: false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "diabetic_toolbox_votes", ["voteable_id", "voteable_type"], name: "index_diabetic_toolbox_votes_on_voteable_id_and_voteable_type", using: :btree
  add_index "diabetic_toolbox_votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], name: "fk_one_vote_per_member", unique: true, using: :btree
  add_index "diabetic_toolbox_votes", ["voter_id", "voter_type"], name: "index_diabetic_toolbox_votes_on_voter_id_and_voter_type", using: :btree

end
