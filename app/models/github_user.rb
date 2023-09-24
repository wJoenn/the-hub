class GithubUser < ApplicationRecord
  include IsGithubModel

  has_many :releases, class_name: "GithubRelease", foreign_key: "author_id", inverse_of: :author, dependent: :destroy
  has_many :repositories,
    class_name: "GithubRepository",
    foreign_key: "owner_id",
    inverse_of: :owner,
    dependent: :destroy

  validates :login, :gh_type, :avatar_url, :html_url, presence: true
end
