class GithubUser < ApplicationRecord
  include IsGithubModel

  has_many :repositories,
    class_name: "GithubRepository",
    foreign_key: "owner_id",
    inverse_of: :owner,
    dependent: :destroy

  validates :login, :avatar_url, :html_url, presence: true
end
