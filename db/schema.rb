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

ActiveRecord::Schema.define(version: 2018_07_30_184637) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bits", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bits_inventions", id: false, force: :cascade do |t|
    t.bigint "bit_id", null: false
    t.bigint "invention_id", null: false
    t.index ["bit_id"], name: "index_bits_inventions_on_bit_id"
    t.index ["invention_id"], name: "index_bits_inventions_on_invention_id"
  end

  create_table "inventions", force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.text "description", null: false
    t.string "username", limit: 255
    t.string "email", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "materials", default: [], null: false, array: true
    t.index ["materials"], name: "index_inventions_on_materials", using: :gin
  end

  add_foreign_key "bits_inventions", "bits"
  add_foreign_key "bits_inventions", "inventions"
end
