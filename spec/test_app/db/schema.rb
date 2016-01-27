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

ActiveRecord::Schema.define(version: 20160127144739) do

  create_table "codifligne_lines", force: :cascade do |t|
    t.string   "stif_id"
    t.string   "name"
    t.string   "short_name"
    t.string   "transport_mode"
    t.string   "private_code"
    t.string   "status"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "codifligne_lines", ["transport_mode", "status"], name: "index_codifligne_lines_on_transport_mode_and_status"

  create_table "codifligne_lines_operators", force: :cascade do |t|
    t.integer "operator_id"
    t.integer "line_id"
  end

  add_index "codifligne_lines_operators", ["line_id"], name: "index_codifligne_lines_operators_on_line_id"
  add_index "codifligne_lines_operators", ["operator_id"], name: "index_codifligne_lines_operators_on_operator_id"

  create_table "codifligne_operators", force: :cascade do |t|
    t.string   "stif_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
