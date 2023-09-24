class GithubRepository < ApplicationRecord
  include IsGithubModel

  has_many :releases,
    class_name: "GithubRelease",
    foreign_key: "repository_id",
    inverse_of: :repository,
    dependent: :destroy

  belongs_to :owner, class_name: "GithubUser"

  validates :full_name, :name, :description, presence: true
  validates :starred, inclusion: [true, false]
end
