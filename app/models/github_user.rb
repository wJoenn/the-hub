class GithubUser < ApplicationRecord
  validates :github_id, :login, :avatar_url, :html_url, presence: true
  validates :github_id, numericality: { greater_than_or_equal_to: 0, only_integer: true }
end
