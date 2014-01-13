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

ActiveRecord::Schema.define(version: 20131230233639) do

  create_table "diploma_works", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "student"
    t.string   "graduation_supervisor"
    t.boolean  "agreed",                default: false
    t.boolean  "approved",              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "grades" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access",          default: "user"
    t.string   "first_name"
    t.string   "second_name"
    t.string   "last_name"
    t.integer  "number"
    t.string   "grade"
    t.string   "user_type",       default: "student"
    t.string   "business"
    t.string   "email"
    t.integer  "active",          default: 0
  end

end
