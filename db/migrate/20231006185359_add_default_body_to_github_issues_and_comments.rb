class AddDefaultBodyToGithubIssuesAndComments < ActiveRecord::Migration[7.1]
  def change
    change_column_default :github_issues, :body, ""
    change_column_default :github_comments, :body, ""
  end
end
