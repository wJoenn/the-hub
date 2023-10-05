class RemoveDefaultHtmlUrlForGithubReleases < ActiveRecord::Migration[7.0]
  def change
    change_column_default :github_releases, :html_url, nil
  end
end
