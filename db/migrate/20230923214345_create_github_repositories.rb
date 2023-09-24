class CreateGithubRepositories < ActiveRecord::Migration[7.0]
  def change
    create_table :github_repositories do |t|
      t.bigint :gid, null: false
      t.string :full_name, null: false
      t.string :name, null: false
      t.string :description, null: false
      t.boolean :starred, null: false, default: true
      t.references :owner, null: false, foreign_key: { to_table: :github_users }

      t.timestamps
    end
  end
end
