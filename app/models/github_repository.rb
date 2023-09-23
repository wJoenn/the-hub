class GithubRepository < ApplicationRecord
  belongs_to :owner, class_name: "GithubUser"

  validates :github_id, :full_name, :name, :description, presence: true
  validates :github_id, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :starred, inclusion: { in: [true, false] }
end
