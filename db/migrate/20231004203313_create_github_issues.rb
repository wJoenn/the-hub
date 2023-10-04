class CreateGithubIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :github_issues do |t|
      t.bigint :gid, null: false
      t.string :html_url, null: false
      t.string :body, null: false
      t.string :status, null: false
      t.string :title, null: false
      t.string :gh_type, null: false
      t.integer :number, null: false
      t.datetime :released_at, null: false
      t.references :author, null: false, foreign_key: { to_table: :github_users }
      t.references :repository, null: false, foreign_key: { to_table: :github_repositories }

      t.timestamps
    end
  end
end
