class AddTypeToGithubUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :github_users, :gh_type, :string, default: "User"
    change_column_null :github_users, :gh_type, false
  end
end
