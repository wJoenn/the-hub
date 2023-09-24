class GithubRepository < ApplicationRecord
  has_many :releases,
    class_name: "GithubRelease",
    foreign_key: "repository_id",
    inverse_of: :repository,
    dependent: :destroy

  belongs_to :owner, class_name: "GithubUser"

  validates :gid, :full_name, :name, :description, presence: true
  validates :gid, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :starred, inclusion: [true, false]
end
