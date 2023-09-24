class AddAuthorToGithubRelease < ActiveRecord::Migration[7.0]
  def change
    add_reference :github_releases, :author, null: false, foreign_key: { to_table: :github_users }
  end
end
