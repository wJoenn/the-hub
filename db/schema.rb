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

ActiveRecord::Schema[7.1].define(version: 2023_10_06_210610) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "github_comments", force: :cascade do |t|
    t.bigint "gid", null: false
    t.string "html_url", null: false
    t.string "body", default: "", null: false
    t.boolean "read", default: false, null: false
    t.datetime "released_at", null: false
    t.bigint "author_id", null: false
    t.bigint "issue_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_github_comments_on_author_id"
    t.index ["issue_id"], name: "index_github_comments_on_issue_id"
  end

  create_table "github_issues", force: :cascade do |t|
    t.bigint "gid", null: false
    t.string "html_url", null: false
    t.string "body", default: "", null: false
    t.string "state", null: false
    t.string "title", null: false
    t.string "gh_type", null: false
    t.integer "number", null: false
    t.datetime "released_at", null: false
    t.bigint "author_id", null: false
    t.bigint "repository_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_github_issues_on_author_id"
    t.index ["repository_id"], name: "index_github_issues_on_repository_id"
  end

  create_table "github_reactions", force: :cascade do |t|
    t.bigint "gid", null: false
    t.bigint "github_user_id", null: false
    t.string "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reactable_type"
    t.bigint "reactable_id"
    t.index ["reactable_type", "reactable_id"], name: "index_github_reactions_on_reactable"
  end

  create_table "github_releases", force: :cascade do |t|
    t.bigint "gid", null: false
    t.string "name", null: false
    t.string "tag_name", null: false
    t.string "body", default: "", null: false
    t.boolean "read", default: false, null: false
    t.datetime "released_at", null: false
    t.bigint "repository_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "author_id", null: false
    t.string "html_url", null: false
    t.index ["author_id"], name: "index_github_releases_on_author_id"
    t.index ["repository_id"], name: "index_github_releases_on_repository_id"
  end

  create_table "github_repositories", force: :cascade do |t|
    t.bigint "gid", null: false
    t.string "full_name", null: false
    t.string "name", null: false
    t.string "description"
    t.boolean "starred", default: true, null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "language"
    t.integer "stargazers_count", null: false
    t.integer "forks_count", null: false
    t.datetime "pushed_at", null: false
    t.string "html_url", null: false
    t.index ["owner_id"], name: "index_github_repositories_on_owner_id"
  end

  create_table "github_users", force: :cascade do |t|
    t.bigint "gid", null: false
    t.string "login", null: false
    t.string "avatar_url", null: false
    t.string "html_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gh_type", default: "User", null: false
    t.string "bio"
    t.string "name"
    t.string "location"
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["active_job_id"], name: "index_good_jobs_on_active_job_id"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at", unique: true
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  add_foreign_key "github_comments", "github_issues", column: "issue_id"
  add_foreign_key "github_comments", "github_users", column: "author_id"
  add_foreign_key "github_issues", "github_repositories", column: "repository_id"
  add_foreign_key "github_issues", "github_users", column: "author_id"
  add_foreign_key "github_releases", "github_repositories", column: "repository_id"
  add_foreign_key "github_releases", "github_users", column: "author_id"
  add_foreign_key "github_repositories", "github_users", column: "owner_id"
end
