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

ActiveRecord::Schema.define(version: 20141117012841) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "members", force: :cascade do |t|
    t.string   "name",            limit: 64,              null: false
    t.string   "security_id",     limit: 64,              null: false
    t.date     "birthdate",                               null: false
    t.integer  "gender",                                  null: false
    t.integer  "member_type",                             null: false
    t.boolean  "permanent",                               null: false
    t.string   "address",                                 null: false
    t.string   "occupation",                              null: false
    t.string   "company",                                 null: false
    t.string   "education",                               null: false
    t.string   "facebook"
    t.integer  "grad_class"
    t.integer  "grad_year"
    t.string   "grad_id",         limit: 16
    t.integer  "grad_department"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "emails",                     default: [], null: false, array: true
    t.string   "phones",                     default: [], null: false, array: true
  end

  add_index "members", ["name"], name: "index_members_on_name", using: :btree
  add_index "members", ["security_id"], name: "index_members_on_security_id", unique: true, using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "year",       null: false
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["member_id"], name: "index_memberships_on_member_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "login",              limit: 64,             null: false
    t.string   "email",                                     null: false
    t.string   "crypted_password",                          null: false
    t.string   "password_salt",                             null: false
    t.string   "persistence_token",                         null: false
    t.integer  "login_count",                   default: 0, null: false
    t.integer  "failed_login_count",            default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "super"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

end
