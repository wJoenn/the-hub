class AddLanguageToGithubRepositories < ActiveRecord::Migration[7.0]
  def change
    add_column :github_repositories, :language, :string
  end
end
