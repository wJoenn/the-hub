class AddHtmlUrlToGithubReleases < ActiveRecord::Migration[7.0]
  def change
    add_column :github_releases, :html_url, :string, default: "https://www.github.com"
    change_column_null :github_releases, :html_url, false
  end
end
