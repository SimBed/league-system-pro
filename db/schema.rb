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

ActiveRecord::Schema[8.0].define(version: 2025_08_13_154503) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "league_auths", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "league_id", null: false
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_league_auths_on_league_id"
    t.index ["role"], name: "index_league_auths_on_role"
    t.index ["user_id"], name: "index_league_auths_on_user_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.string "name", null: false
    t.string "season", null: false
    t.integer "participants_per_match", null: false
    t.string "participant_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_leagues_on_name"
    t.index ["season"], name: "index_leagues_on_season"
  end

  create_table "matches", force: :cascade do |t|
    t.date "date", null: false
    t.bigint "league_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_matches_on_date"
    t.index ["league_id"], name: "index_matches_on_league_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "league_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_memberships_on_league_id"
    t.index ["player_id"], name: "index_memberships_on_player_id"
  end

  create_table "participations", force: :cascade do |t|
    t.decimal "score", precision: 5, scale: 1, null: false
    t.bigint "match_id", null: false
    t.string "participatable_type", null: false
    t.bigint "participatable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_participations_on_match_id"
    t.index ["participatable_type", "participatable_id"], name: "index_participations_on_participatable"
  end

  create_table "player_auths", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "player_id", null: false
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_player_auths_on_player_id"
    t.index ["role"], name: "index_player_auths_on_role"
    t.index ["user_id"], name: "index_player_auths_on_user_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name"], name: "index_players_on_first_name"
    t.index ["last_name"], name: "index_players_on_last_name"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_teams_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "league_auths", "leagues"
  add_foreign_key "league_auths", "users"
  add_foreign_key "matches", "leagues"
  add_foreign_key "memberships", "leagues"
  add_foreign_key "memberships", "players"
  add_foreign_key "participations", "matches"
  add_foreign_key "player_auths", "players"
  add_foreign_key "player_auths", "users"
  add_foreign_key "players", "teams"
end
