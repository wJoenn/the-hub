class CreateGithubUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :github_users do |t|
      t.bigint :gid, null: false
      t.string :login, null: false
      t.string :avatar_url, null: false
      t.string :html_url, null: false

      t.timestamps
    end
  end
end
