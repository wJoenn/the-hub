class RemoveReactionColumnsFromGithubReleases < ActiveRecord::Migration[7.0]
  def change
    remove_column :github_releases, :reactions_plus_one
    remove_column :github_releases, :reactions_minus_one
    remove_column :github_releases, :reactions_confused
    remove_column :github_releases, :reactions_eyes
    remove_column :github_releases, :reactions_heart
    remove_column :github_releases, :reactions_hooray
    remove_column :github_releases, :reactions_laugh
    remove_column :github_releases, :reactions_rocket
  end
end
