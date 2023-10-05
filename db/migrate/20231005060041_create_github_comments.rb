class CreateGithubComments < ActiveRecord::Migration[7.0]
  def change
    create_table :github_comments do |t|
      t.bigint :gid, null: false
      t.string :html_url, null: false
      t.string :body, null: false
      t.boolean :read, null: false, default: false
      t.datetime :released_at, null: false
      t.references :author, null: false, foreign_key: { to_table: :github_users }
      t.references :issue, null: false, foreign_key: { to_table: :github_issues }

      t.timestamps
    end
  end
end
