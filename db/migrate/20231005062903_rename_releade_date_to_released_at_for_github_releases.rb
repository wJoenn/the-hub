class RenameReleadeDateToReleasedAtForGithubReleases < ActiveRecord::Migration[7.0]
  def change
    rename_column :github_releases, :release_date, :released_at
  end
end
