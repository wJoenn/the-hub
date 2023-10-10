class AddIndexOnReleasedAtToFeedItems < ActiveRecord::Migration[7.1]
  def change
    add_index :github_comments, :released_at
    add_index :github_releases, :released_at
  end
end
