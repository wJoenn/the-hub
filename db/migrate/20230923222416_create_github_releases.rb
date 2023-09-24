class CreateGithubReleases < ActiveRecord::Migration[7.0]
  def change
    create_table :github_releases do |t|
      t.bigint :gid, null: false
      t.string :name, null: false
      t.string :tag_name, null: false
      t.string :body, null: false, default: ""
      t.integer :reactions_plus_one, null: false, default: 0
      t.integer :reactions_minus_one, null: false, default: 0
      t.integer :reactions_confused, null: false, default: 0
      t.integer :reactions_eyes, null: false, default: 0
      t.integer :reactions_heart, null: false, default: 0
      t.integer :reactions_hooray, null: false, default: 0
      t.integer :reactions_laugh, null: false, default: 0
      t.integer :reactions_rocket, null: false, default: 0
      t.boolean :read, null: false, default: false
      t.datetime :release_date, null: false
      t.references :repository, null: false, foreign_key: { to_table: :github_repositories }

      t.timestamps
    end
  end
end
