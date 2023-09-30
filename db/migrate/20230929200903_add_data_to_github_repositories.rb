class AddDataToGithubRepositories < ActiveRecord::Migration[7.0]
  def change
    add_column :github_repositories, :stargazers_count, :integer
    add_column :github_repositories, :forks_count, :integer
    add_column :github_repositories, :pushed_at, :datetime
    add_column :github_repositories, :html_url, :string

    GithubRepository.update_all(stargazers_count: 0, forks_count: 0, pushed_at: 1.month.ago, html_url: "www.github.com")

    change_column_null :github_repositories, :stargazers_count, false
    change_column_null :github_repositories, :forks_count, false
    change_column_null :github_repositories, :pushed_at, false
    change_column_null :github_repositories, :html_url, false

    change_column_null :github_repositories, :description, true
  end
end
