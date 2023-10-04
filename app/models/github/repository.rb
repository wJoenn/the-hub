module Github
  class Repository < ApplicationRecord
    include IsGithubModel

    has_many :issues, class_name: "Github::Issue", inverse_of: :repository, dependent: :destroy
    has_many :releases, class_name: "Github::Release", inverse_of: :repository, dependent: :destroy

    belongs_to :owner, class_name: "Github::User"

    validates :full_name, :name, :stargazers_count, :forks_count, :pushed_at, :html_url, presence: true
    validates :stargazers_count, :forks_count, numericality: { greater_than_or_equal_to: 0, only_integer: true }
    validates :starred, inclusion: [true, false]
    validate :pushed_at_is_a_datetime

    def pushed_at_is_a_datetime
      errors.add(:pushed_at, "must be a valid date") unless pushed_at.is_a? ActiveSupport::TimeWithZone
    end
  end
end
