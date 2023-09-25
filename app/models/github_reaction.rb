class GithubReaction < ApplicationRecord
  include IsGithubModel

  belongs_to :release, class_name: "GithubRelease"

  validates :github_user_id, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :content, presence: true, inclusion: %w[+1 -1 confused eyes heart hooray laugh rocket]
end
