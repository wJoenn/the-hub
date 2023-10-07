class AddTypeToModels < ActiveRecord::Migration[7.1]
  def change
    add_column :github_comments, :feed_type, :string, null: false, default: "GithubComment"
    add_column :github_issues, :feed_type, :string, null: false, default: "GithubIssue"
    add_column :github_releases, :feed_type, :string, null: false, default: "GithubRelease"
  end
end
