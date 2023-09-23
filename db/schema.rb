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

ActiveRecord::Schema[7.0].define(version: 2023_09_23_214345) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "github_repositories", force: :cascade do |t|
    t.bigint "github_id", null: false
    t.string "full_name", null: false
    t.string "name", null: false
    t.string "description", null: false
    t.boolean "starred", default: true, null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_github_repositories_on_owner_id"
  end

  create_table "github_users", force: :cascade do |t|
    t.bigint "github_id", null: false
    t.string "login", null: false
    t.string "avatar_url", null: false
    t.string "html_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "github_repositories", "github_users", column: "owner_id"
end
