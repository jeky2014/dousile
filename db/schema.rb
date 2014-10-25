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

ActiveRecord::Schema.define(version: 20141024062308) do

  create_table "articles", force: true do |t|
    t.integer  "source",     default: 0,     null: false
    t.integer  "state",      default: 0,     null: false
    t.string   "title",                      null: false
    t.text     "content",                    null: false
    t.integer  "hitt",       default: 0,     null: false
    t.integer  "hitm",       default: 0,     null: false
    t.integer  "sign",       default: 0,     null: false
    t.boolean  "haspic",     default: false, null: false
    t.string   "picpath"
    t.string   "tag"
    t.datetime "pubtime",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts2", id: false, force: true do |t|
    t.integer  "id",       default: 0, null: false
    t.string   "title"
    t.text     "content"
    t.integer  "cateid",   default: 0, null: false
    t.integer  "hit",      default: 0, null: false
    t.datetime "postdate",             null: false
  end

  create_table "upyuns", force: true do |t|
    t.string   "url",                    null: false
    t.integer  "width",      default: 0, null: false
    t.integer  "height",     default: 0, null: false
    t.integer  "state",      default: 1, null: false
    t.integer  "source",     default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
