class AddDataToGithubUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :github_users, :bio, :string
    add_column :github_users, :name, :string
    add_column :github_users, :location, :string
  end
end
