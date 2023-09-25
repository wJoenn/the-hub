class CreateGithubReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :github_reactions do |t|
      t.bigint :gid, null: false
      t.bigint :github_user_id, null: false
      t.string :content, null: false
      t.references :release, null: false, foreign_key: { to_table: :github_releases }

      t.timestamps
    end
  end
end
