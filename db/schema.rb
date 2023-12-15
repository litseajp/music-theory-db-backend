# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_11_05_143136) do
  create_table "constant_intervals", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "constant_scale_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "constant_scale_tones", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "scale_id"
    t.integer "semitone_distance", null: false
    t.integer "alphabet_distance"
    t.bigint "interval_id"
    t.bigint "tone_type_id"
    t.index ["interval_id"], name: "index_constant_scale_tones_on_interval_id"
    t.index ["scale_id"], name: "index_constant_scale_tones_on_scale_id"
    t.index ["tone_type_id"], name: "index_constant_scale_tones_on_tone_type_id"
  end

  create_table "constant_scales", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "scale_category_id"
    t.string "path", null: false
    t.string "name", null: false
    t.text "description"
    t.index ["scale_category_id"], name: "index_constant_scales_on_scale_category_id"
  end

  create_table "constant_tone_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
  end

  add_foreign_key "constant_scale_tones", "constant_intervals", column: "interval_id"
  add_foreign_key "constant_scale_tones", "constant_scales", column: "scale_id"
  add_foreign_key "constant_scale_tones", "constant_tone_types", column: "tone_type_id"
  add_foreign_key "constant_scales", "constant_scale_categories", column: "scale_category_id"
end
