class RenameStatusToStateForGithubIssues < ActiveRecord::Migration[7.1]
  def change
    rename_column :github_issues, :status, :state
  end
end
