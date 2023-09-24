class GithubUser < ApplicationRecord
  has_many :repositories,
    class_name: "GithubRepository",
    foreign_key: "owner_id",
    inverse_of: :owner,
    dependent: :destroy

  validates :gid, :login, :avatar_url, :html_url, presence: true
  validates :gid, numericality: { greater_than_or_equal_to: 0, only_integer: true }
end
