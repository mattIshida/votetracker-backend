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

ActiveRecord::Schema[7.0].define(version: 2023_04_11_191743) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bills", id: false, force: :cascade do |t|
    t.string "id"
    t.string "title"
    t.string "short_title"
    t.string "sponsor_id"
    t.string "congressdotgov_url"
    t.boolean "active"
    t.string "enacted"
    t.string "primary_subject"
    t.string "summary_short"
    t.string "latest_major_action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", id: false, force: :cascade do |t|
    t.string "id"
    t.string "chamber"
    t.integer "congress"
    t.string "first_name"
    t.string "last_name"
    t.string "short_title"
    t.string "party"
    t.boolean "in_office"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nominations", id: false, force: :cascade do |t|
    t.string "id"
    t.integer "congress"
    t.string "description"
    t.string "status"
    t.date "latest_action_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "positions", force: :cascade do |t|
    t.string "member_id"
    t.string "vote_id"
    t.string "vote_position"
    t.string "party"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.string "url_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "bill_id"
    t.integer "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "votes", id: false, force: :cascade do |t|
    t.string "id"
    t.integer "congress"
    t.string "chamber"
    t.integer "session"
    t.integer "roll_call"
    t.string "vote_uri"
    t.string "votable_type"
    t.string "votable_id"
    t.string "question"
    t.string "question_text"
    t.string "description"
    t.string "vote_type"
    t.date "date"
    t.string "time"
    t.string "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
